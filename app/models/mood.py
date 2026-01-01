from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from datetime import datetime
from app.db.base_class import Base
from enum import Enum as PyEnum

class MoodType(str, PyEnum):
    HAPPY = "HAPPY"
    SAD = "SAD"
    ANXIOUS = "ANXIOUS"
    STRESSED = "STRESSED"
    CALM = "CALM"
    ANGRY = "ANGRY"
    TIRED = "TIRED"
    EXCITED = "EXCITED"

class MoodEntry(Base):
    __tablename__ = "mood_entries"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    mood = Column(Enum(MoodType), nullable=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationship
    user = relationship("User", back_populates="mood_entries")
