from pydantic import BaseModel, Field, field_serializer
from typing import List, Optional
from datetime import datetime, timezone
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
    
    @field_serializer('created_at')
    def serialize_created_at(self, value: datetime) -> str:
        # Ensure UTC timezone and return ISO format
        if value.tzinfo is None:
            value = value.replace(tzinfo=timezone.utc)
        return value.isoformat()
    
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

class CreateChatRequest(BaseModel):
    doctor_id: int = Field(..., description="ID of the doctor to start chat with")