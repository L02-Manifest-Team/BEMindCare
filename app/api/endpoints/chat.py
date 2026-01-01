from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, timedelta

from app.db.session import get_db
from app.models.user import User
from app.crud import chat as crud_chat
from app.schemas.chat import Chat, Message, MessageCreate, ChatListResponse
from app.core.security import get_current_user

router = APIRouter(
    prefix="",
    tags=["Chats"],
    responses={404: {"description": "Not found"}},
)

@router.get(
    "/",
    response_model=ChatListResponse,
    summary="Get all chats",
    description="Retrieve all chat conversations for the authenticated user."
)
async def get_user_chats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get all chat conversations for the current user.
    
    Returns a list of chat conversations with the last message and unread count.
    """
    chats = crud_chat.get_user_chats(db, current_user.id)
    
    # Format response using Pydantic models
    from app.schemas.chat import Chat, Message as MessageSchema
    from app.schemas.user import UserBase
    
    response_chats = []
    for chat in chats:
        # Get other participants (excluding current user)
        other_participants = []
        for p in chat.participants:
            if p.user_id != current_user.id:
                user_base = UserBase(
                    email=p.user.email,
                    full_name=p.user.full_name,
                    phone_number=p.user.phone_number,
                    avatar=p.user.avatar
                )
                participant = {
                    **user_base.model_dump(),
                    'id': p.user.id,
                    'role': p.user.role.value
                }
                other_participants.append(participant)
        
        # Get last message
        last_message = None
        if chat.messages:
            msg = chat.messages[0]  # Assuming messages are ordered by created_at desc
            last_message = MessageSchema(
                id=msg.id,
                content=msg.content,
                sender_id=msg.sender_id,
                chat_id=msg.chat_id,
                created_at=msg.created_at,
                read=msg.read
            )
        
        # Count unread messages
        unread_count = sum(1 for m in chat.messages 
                          if not m.read and m.sender_id != current_user.id)
        
        # Create chat response
        chat_response = Chat(
            id=chat.id,
            participants=other_participants,
            last_message=last_message,
            unread_count=unread_count
        )
        response_chats.append(chat_response)
    
    return {'data': response_chats}

@router.post(
    "/{chat_id}/messages",
    response_model=Message,
    status_code=status.HTTP_201_CREATED,
    summary="Send a message",
    description="Send a new message in an existing chat conversation.",
    responses={
        404: {"description": "Chat not found or user not a participant"},
        201: {"description": "Message sent successfully"}
    }
)
async def send_message(
    chat_id: int,
    message_in: MessageCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Send a new message in a chat.
    
    - **chat_id**: ID of the chat to send message to
    - **content**: Message content (max 1000 characters)
    
    Returns the created message with its details.
    """
    # Verify user is a participant in the chat
    chat = db.query(chat_models.Chat).join(
        chat_models.ChatParticipant,
        chat_models.Chat.id == chat_models.ChatParticipant.chat_id
    ).filter(
        chat_models.Chat.id == chat_id,
        chat_models.ChatParticipant.user_id == current_user.id
    ).first()
    
    if not chat:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat not found"
        )
    
    # Create message
    message = crud_chat.create_message(
        db=db,
        chat_id=chat_id,
        sender_id=current_user.id,
        content=message_in.content
    )
    
    return {
        'id': str(message.id),
        'content': message.content,
        'senderId': str(message.sender_id),
        'chatId': str(message.chat_id),
        'createdAt': message.created_at.isoformat(),
        'read': message.read
    }

@router.get(
    "/{chat_id}/messages",
    response_model=List[Message],
    summary="Get chat messages",
    description="Retrieve messages from a specific chat conversation.",
    responses={
        404: {"description": "Chat not found or user not a participant"},
        200: {"description": "List of messages in the chat"}
    }
)
async def get_chat_messages(
    chat_id: int,
    skip: int = Query(0, ge=0, description="Number of messages to skip"),
    limit: int = Query(100, ge=1, le=200, description="Maximum number of messages to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get messages from a specific chat conversation.
    
    - **chat_id**: ID of the chat to get messages from
    - **skip**: Number of messages to skip (for pagination)
    - **limit**: Maximum number of messages to return (max 200)
    
    Returns a list of messages in the chat, ordered by creation date (newest first).
    """
    # Verify user is a participant in the chat
    chat = db.query(chat_models.Chat).join(
        chat_models.ChatParticipant,
        chat_models.Chat.id == chat_models.ChatParticipant.chat_id
    ).filter(
        chat_models.Chat.id == chat_id,
        chat_models.ChatParticipant.user_id == current_user.id
    ).first()
    
    if not chat:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat not found"
        )
    
    # Mark messages as read
    crud_chat.mark_messages_as_read(db, chat_id, current_user.id)
    
    # Get messages
    messages = crud_chat.get_chat_messages(db, chat_id, skip, limit)
    
    return [
        {
            'id': str(msg.id),
            'content': msg.content,
            'senderId': str(msg.sender_id),
            'chatId': str(msg.chat_id),
            'createdAt': msg.created_at.isoformat(),
            'read': msg.read
        }
        for msg in messages
    ]
