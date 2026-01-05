from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class JournalBase(BaseModel):
    content: str = Field(..., min_length=1, max_length=5000)
    title: Optional[str] = Field(None, max_length=255)

class JournalCreate(JournalBase):
    pass

class JournalUpdate(BaseModel):
    content: Optional[str] = Field(None, min_length=1, max_length=5000)
    title: Optional[str] = Field(None, max_length=255)

class JournalResponse(JournalBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class JournalListResponse(BaseModel):
    data: list[JournalResponse]
    total: int
