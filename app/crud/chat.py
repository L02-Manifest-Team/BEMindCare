from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from app.models.chat import Chat, ChatParticipant, Message
from app.models.user import User

def get_or_create_chat(db: Session, user1_id: int, user2_id: int) -> Chat:
    from sqlalchemy.orm import joinedload
    
    # Find existing chat between two users
    chat = db.query(Chat)\
        .join(ChatParticipant, Chat.id == ChatParticipant.chat_id)\
        .filter(ChatParticipant.user_id.in_([user1_id, user2_id]))\
        .group_by(Chat.id)\
        .having(func.count(ChatParticipant.id) == 2)\
        .options(
            joinedload(Chat.participants).joinedload(ChatParticipant.user),
            joinedload(Chat.messages)
        )\
        .first()
    
    if not chat:
        # Create new chat
        chat = Chat()
        db.add(chat)
        db.flush()
        
        # Add participants
        for user_id in [user1_id, user2_id]:
            participant = ChatParticipant(chat_id=chat.id, user_id=user_id)
            db.add(participant)
        
        db.commit()
        db.refresh(chat)
        
        # Reload with relationships
        chat = db.query(Chat)\
            .filter(Chat.id == chat.id)\
            .options(
                joinedload(Chat.participants).joinedload(ChatParticipant.user),
                joinedload(Chat.messages)
            )\
            .first()
    
    return chat

def create_message(db: Session, chat_id: int, sender_id: int, content: str) -> Message:
    message = Message(
        chat_id=chat_id,
        sender_id=sender_id,
        content=content,
        read=False
    )
    db.add(message)
    db.commit()
    db.refresh(message)
    return message

def get_user_chats(db: Session, user_id: int) -> List[Chat]:
    from sqlalchemy.orm import joinedload
    
    return db.query(Chat)\
        .join(ChatParticipant, Chat.id == ChatParticipant.chat_id)\
        .filter(ChatParticipant.user_id == user_id)\
        .options(
            joinedload(Chat.participants).joinedload(ChatParticipant.user),
            joinedload(Chat.messages)
        )\
        .all()

def get_chat_messages(db: Session, chat_id: int, skip: int = 0, limit: int = 100) -> List[Message]:
    return db.query(Message)\
        .filter(Message.chat_id == chat_id)\
        .order_by(Message.created_at.desc())\
        .offset(skip)\
        .limit(limit)\
        .all()

def mark_messages_as_read(db: Session, chat_id: int, user_id: int):
    db.query(Message)\
        .filter(Message.chat_id == chat_id, Message.sender_id != user_id)\
        .update({Message.read: True}, synchronize_session=False)
    db.commit()
