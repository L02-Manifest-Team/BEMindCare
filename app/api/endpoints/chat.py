from fastapi import APIRouter, Depends, HTTPException, status, Query, WebSocket, WebSocketDisconnect
from sqlalchemy.orm import Session
from typing import List, Optional, Dict
from datetime import datetime, timedelta
import json

from app.db.session import get_db
from app.models.user import User
from app.models import chat as chat_models
from app.crud import chat as crud_chat
from app.schemas.chat import Chat, Message, MessageCreate, ChatListResponse, CreateChatRequest
from app.core.security import get_current_user, verify_token

router = APIRouter(
    prefix="",
    tags=["Chats"],
    responses={404: {"description": "Not found"}},
)

# Store active WebSocket connections: {user_id: {chat_id: websocket}}
active_connections: Dict[int, Dict[int, WebSocket]] = {}

async def get_user_from_token(token: str, db: Session) -> Optional[User]:
    """Verify token and get user"""
    try:
        payload = verify_token(token)
        # Token sub contains user email, not user_id
        email = payload.get("sub")
        if not email:
            return None
        user = db.query(User).filter(User.email == email).first()
        return user
    except Exception:
        return None

@router.websocket("/ws/{chat_id}")
async def websocket_endpoint(websocket: WebSocket, chat_id: int):
    """
    WebSocket endpoint for real-time chat messaging.
    Connect with: ws://host/chats/ws/{chat_id}?token={access_token}
    """
    # Get token from query params
    token = websocket.query_params.get("token")
    
    if not token:
        await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
        return
    
    # Get database session
    db = next(get_db())
    
    try:
        # Verify user
        user = await get_user_from_token(token, db)
        if not user:
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        
        # Verify user is a participant in the chat
        chat = db.query(chat_models.Chat).join(
            chat_models.ChatParticipant,
            chat_models.Chat.id == chat_models.ChatParticipant.chat_id
        ).filter(
            chat_models.Chat.id == chat_id,
            chat_models.ChatParticipant.user_id == user.id
        ).first()
        
        if not chat:
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        
        # Accept connection
        await websocket.accept()
        
        # Store connection
        if user.id not in active_connections:
            active_connections[user.id] = {}
        active_connections[user.id][chat_id] = websocket
        
        print(f"[WebSocket] User {user.id} connected to chat {chat_id}")
        print(f"[WebSocket] Total active connections: {len(active_connections)}")
        print(f"[WebSocket] Active users: {list(active_connections.keys())}")
        
        while True:
            # Receive message from client
            data = await websocket.receive_text()
            message_data = json.loads(data)
            
            # Handle different message types
            if message_data.get("type") == "ping":
                # Heartbeat to keep connection alive
                await websocket.send_text(json.dumps({"type": "pong"}))
            elif message_data.get("type") == "message":
                # Send message
                content = message_data.get("content", "")
                if content:
                    # Create message in database
                    message = crud_chat.create_message(
                        db=db,
                        chat_id=chat_id,
                        sender_id=user.id,
                        content=content
                    )
                    db.commit()  # Commit to ensure message is saved
                    
                    # Broadcast to all participants in this chat
                    chat_participants = db.query(chat_models.ChatParticipant).filter(
                        chat_models.ChatParticipant.chat_id == chat_id
                    ).all()
                    
                    # Prepare message response
                    from app.schemas.chat import Message as MessageSchema
                    message_response = MessageSchema(
                        id=message.id,
                        content=message.content,
                        sender_id=message.sender_id,
                        chat_id=message.chat_id,
                        created_at=message.created_at,
                        read=message.read
                    )
                    
                    # Send to all participants
                    print(f"[WebSocket] Broadcasting message {message.id} to {len(chat_participants)} participants")
                    print(f"[WebSocket] Active connections: {list(active_connections.keys())}")
                    
                    for participant in chat_participants:
                        participant_id = participant.user_id
                        print(f"[WebSocket] Checking participant {participant_id}, has connection: {participant_id in active_connections}")
                        
                        if participant_id in active_connections and chat_id in active_connections[participant_id]:
                            try:
                                print(f"[WebSocket] Sending message to participant {participant_id}")
                                await active_connections[participant_id][chat_id].send_text(
                                    json.dumps({
                                        "type": "new_message",
                                        "message": message_response.model_dump()
                                    })
                                )
                                print(f"[WebSocket] Successfully sent to participant {participant_id}")
                            except Exception as e:
                                print(f"[WebSocket] Error sending to participant {participant_id}: {e}")
                                # Remove dead connection
                                if participant_id in active_connections:
                                    active_connections[participant_id].pop(chat_id, None)
                        else:
                            print(f"[WebSocket] Participant {participant_id} not connected (has connection: {participant_id in active_connections}, has chat: {participant_id in active_connections and chat_id in active_connections[participant_id] if participant_id in active_connections else False})")
    except WebSocketDisconnect:
        pass
    except Exception as e:
        if __DEV__:
            print(f"[WebSocket] Error: {e}")
    finally:
        # Remove connection
        if 'user' in locals() and user.id in active_connections:
            active_connections[user.id].pop(chat_id, None)
            if not active_connections[user.id]:
                del active_connections[user.id]
        db.close()

@router.post(
    "/",
    response_model=Chat,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new chat",
    description="Create a new chat conversation with a doctor. If a chat already exists, returns the existing chat."
)
async def create_chat(
    chat_data: CreateChatRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new chat conversation with a doctor.
    
    - **doctor_id**: ID of the doctor to start chat with
    
    Returns the chat (newly created or existing if already exists).
    """
    # Verify doctor exists and is a doctor
    doctor = db.query(User).filter(
        User.id == chat_data.doctor_id,
        User.role == "DOCTOR"
    ).first()
    
    if not doctor:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Doctor not found"
        )
    
    # Check if current user is a patient
    if current_user.role != "PATIENT":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only patients can create chats with doctors"
        )
    
    # Get or create chat
    chat = crud_chat.get_or_create_chat(
        db=db,
        user1_id=current_user.id,
        user2_id=chat_data.doctor_id
    )
    
    # Format response
    from app.schemas.chat import ChatParticipant
    from app.schemas.user import UserBase
    
    # Get other participants (excluding current user)
    participants = []
    for participant in chat.participants:
        if participant.user_id != current_user.id:
            participants.append(ChatParticipant(
                id=participant.user.id,
                email=participant.user.email,
                full_name=participant.user.full_name,
                phone_number=participant.user.phone_number,
                avatar=participant.user.avatar,
                role=participant.user.role
            ))
    
    # Get last message if exists
    last_message = None
    if chat.messages:
        latest_msg = sorted(chat.messages, key=lambda m: m.created_at, reverse=True)[0]
        last_message = Message(
            id=latest_msg.id,
            content=latest_msg.content,
            sender_id=latest_msg.sender_id,
            chat_id=latest_msg.chat_id,
            created_at=latest_msg.created_at,
            read=latest_msg.read
        )
    
    # Count unread messages
    unread_count = db.query(chat_models.Message).join(
        chat_models.ChatParticipant,
        chat_models.Message.chat_id == chat_models.ChatParticipant.chat_id
    ).filter(
        chat_models.Message.chat_id == chat.id,
        chat_models.Message.sender_id != current_user.id,
        chat_models.Message.read == False
    ).count()
    
    return Chat(
        id=chat.id,
        participants=participants,
        last_message=last_message,
        unread_count=unread_count
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
    Get all chat conversations for the authenticated user.
    
    Returns a list of chats with:
    - Chat ID
    - Participants (excluding current user)
    - Last message (if exists)
    - Unread message count
    """
    # Get all chats where user is a participant
    chats = db.query(chat_models.Chat).join(
        chat_models.ChatParticipant,
        chat_models.Chat.id == chat_models.ChatParticipant.chat_id
    ).filter(
        chat_models.ChatParticipant.user_id == current_user.id
    ).all()

    # Format response
    from app.schemas.chat import ChatParticipant
    response_chats = []
    
    for chat in chats:
        # Get other participants (excluding current user)
        participants = []
        for participant in chat.participants:
            if participant.user_id != current_user.id:
                participants.append(ChatParticipant(
                    id=participant.user.id,
                    email=participant.user.email,
                    full_name=participant.user.full_name,
                    phone_number=participant.user.phone_number,
                    avatar=participant.user.avatar,
                    role=participant.user.role
                ))
        
        # Get last message if exists
        last_message = None
        if chat.messages:
            latest_msg = sorted(chat.messages, key=lambda m: m.created_at, reverse=True)[0]
            last_message = Message(
                id=latest_msg.id,
                content=latest_msg.content,
                sender_id=latest_msg.sender_id,
                chat_id=latest_msg.chat_id,
                created_at=latest_msg.created_at,
                read=latest_msg.read
            )
        
        # Count unread messages
        unread_count = db.query(chat_models.Message).join(
            chat_models.ChatParticipant,
            chat_models.Message.chat_id == chat_models.ChatParticipant.chat_id
        ).filter(
            chat_models.Message.chat_id == chat.id,
            chat_models.Message.sender_id != current_user.id,
            chat_models.Message.read == False
        ).count()
        
        response_chats.append(Chat(
            id=chat.id,
            participants=participants,
            last_message=last_message,
            unread_count=unread_count
        ))
    

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
    
    # Broadcast via WebSocket if connections exist
    chat_participants = db.query(chat_models.ChatParticipant).filter(
        chat_models.ChatParticipant.chat_id == chat_id
    ).all()
    
    from app.schemas.chat import Message as MessageSchema
    message_response = MessageSchema(
        id=message.id,
        content=message.content,
        sender_id=message.sender_id,
        chat_id=message.chat_id,
        created_at=message.created_at,
        read=message.read
    )
    
    # Send to all active WebSocket connections
    print(f"[API] Broadcasting message {message.id} via API to {len(chat_participants)} participants")
    print(f"[API] Active connections: {list(active_connections.keys())}")
    
    for participant in chat_participants:
        participant_id = participant.user_id
        print(f"[API] Checking participant {participant_id}, has connection: {participant_id in active_connections}")
        
        if participant_id in active_connections and chat_id in active_connections[participant_id]:
            try:
                print(f"[API] Sending message to participant {participant_id}")
                await active_connections[participant_id][chat_id].send_text(
                    json.dumps({
                        "type": "new_message",
                        "message": message_response.model_dump()
                    })
                )
                print(f"[API] Successfully sent to participant {participant_id}")
            except Exception as e:
                print(f"[API] Error sending to participant {participant_id}: {e}")
                # Remove dead connection
                if participant_id in active_connections:
                    active_connections[participant_id].pop(chat_id, None)
        else:
            print(f"[API] Participant {participant_id} not connected")
    
    # Return using Pydantic schema
    return message_response

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
    
    # Return using Pydantic schema
    from app.schemas.chat import Message as MessageSchema
    return [
        MessageSchema(
            id=msg.id,
            content=msg.content,
            sender_id=msg.sender_id,
            chat_id=msg.chat_id,
            created_at=msg.created_at,
            read=msg.read
        )
        for msg in messages
    ]
