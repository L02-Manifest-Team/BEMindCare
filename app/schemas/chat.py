from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
from app.schemas.user import UserBase

class MessageBase(BaseModel):
    content: str = Field(..., min_length=1, max_length=1000)

class MessageCreate(MessageBase):
    pass

class Message(MessageBase):
    id: int
    sender_id: int
    chat_id: int
    created_at: datetime
    read: bool
    
    class Config:
        from_attributes = True

class ChatParticipant(UserBase):
    id: int
    role: str
    
    class Config:
        from_attributes = True

class ChatBase(BaseModel):
    pass

class Chat(ChatBase):
    id: int
    participants: List[ChatParticipant]
    last_message: Optional[Message] = None
    unread_count: int = 0
    
    class Config:
        from_attributes = True

class ChatListResponse(BaseModel):
    data: List[Chat]
