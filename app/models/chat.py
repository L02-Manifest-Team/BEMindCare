from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Boolean, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from app.db.base_class import Base

class Chat(Base):
    __tablename__ = "chats"
    
    id = Column(Integer, primary_key=True, index=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    participants = relationship("ChatParticipant", back_populates="chat", cascade="all, delete-orphan")
    messages = relationship("Message", back_populates="chat", cascade="all, delete-orphan")

class ChatParticipant(Base):
    __tablename__ = "chat_participants"
    
    id = Column(Integer, primary_key=True, index=True)
    chat_id = Column(Integer, ForeignKey("chats.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    
    # Relationships
    chat = relationship("Chat", back_populates="participants")
    user = relationship("User", back_populates="chat_participants")

class Message(Base):
    __tablename__ = "messages"
    
    id = Column(Integer, primary_key=True, index=True)
    chat_id = Column(Integer, ForeignKey("chats.id", ondelete="CASCADE"), nullable=False)
    sender_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    read = Column(Boolean, default=False)
    
    # Relationships
    chat = relationship("Chat", back_populates="messages")
    sender = relationship("User", back_populates="messages")
