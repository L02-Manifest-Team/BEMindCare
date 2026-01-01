from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum

class MoodType(str, Enum):
    HAPPY = "HAPPY"
    SAD = "SAD"
    ANXIOUS = "ANXIOUS"
    STRESSED = "STRESSED"
    CALM = "CALM"
    ANGRY = "ANGRY"
    TIRED = "TIRED"
    EXCITED = "EXCITED"

class MoodBase(BaseModel):
    mood: MoodType
    notes: Optional[str] = Field(None, max_length=1000)

class MoodCreate(MoodBase):
    pass

class Mood(MoodBase):
    id: int
    user_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class MoodListResponse(BaseModel):
    data: List[Mood]
