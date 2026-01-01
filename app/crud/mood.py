from sqlalchemy.orm import Session
from sqlalchemy import desc
from datetime import datetime, timedelta
from typing import List, Optional
from app.models.mood import MoodEntry, MoodType

def create_mood_entry(
    db: Session, 
    user_id: int, 
    mood: MoodType, 
    notes: Optional[str] = None
) -> MoodEntry:
    db_mood = MoodEntry(
        user_id=user_id,
        mood=mood,
        notes=notes
    )
    db.add(db_mood)
    db.commit()
    db.refresh(db_mood)
    return db_mood

def get_mood_history(
    db: Session, 
    user_id: int, 
    start_date: Optional[datetime] = None,
    end_date: Optional[datetime] = None,
    limit: int = 30
) -> List[MoodEntry]:
    query = db.query(MoodEntry).filter(MoodEntry.user_id == user_id)
    
    if start_date:
        query = query.filter(MoodEntry.created_at >= start_date)
    if end_date:
        # Include the entire end date
        end_of_day = end_date + timedelta(days=1)
        query = query.filter(MoodEntry.created_at < end_of_day)
    
    return query.order_by(desc(MoodEntry.created_at)).limit(limit).all()

def get_latest_mood_entry(db: Session, user_id: int) -> Optional[MoodEntry]:
    return db.query(MoodEntry)\
        .filter(MoodEntry.user_id == user_id)\
        .order_by(desc(MoodEntry.created_at))\
        .first()
