from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, timedelta

from app.db.session import get_db
from app.models.user import User
from app.models.mood import MoodType
from app.crud import mood as crud_mood
from app.schemas.mood import Mood, MoodCreate, MoodListResponse
from app.core.security import get_current_user

router = APIRouter(
    prefix="",
    tags=["Mood Tracking"],
    responses={
        401: {"description": "Unauthorized"},
        404: {"description": "Not found"},
        422: {"description": "Validation Error"}
    }
)

@router.post(
    "/",
    response_model=Mood,
    status_code=status.HTTP_201_CREATED,
    summary="Create mood entry",
    description="Create a new mood tracking entry for the authenticated user.",
    responses={
        201: {"description": "Mood entry created successfully"},
        400: {"description": "Invalid mood type or data validation failed"}
    }
)
async def create_mood(
    mood_in: MoodCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new mood tracking entry.
    
    - **mood**: Current mood (HAPPY, SAD, ANXIOUS, STRESSED, CALM, ANGRY, TIRED, EXCITED)
    - **notes**: Optional notes about the mood (max 500 characters)
    
    Returns the created mood entry with timestamp.
    """
    mood_entry = crud_mood.create_mood_entry(
        db=db,
        user_id=current_user.id,
        mood=mood_in.mood,
        notes=mood_in.notes
    )
    
    return Mood(
        id=mood_entry.id,
        user_id=mood_entry.user_id,
        mood=mood_entry.mood,
        notes=mood_entry.notes,
        created_at=mood_entry.created_at
    )

@router.get(
    "/history",
    response_model=MoodListResponse,
    summary="Get mood history",
    description="Retrieve mood history with optional date filtering.",
    responses={
        200: {"description": "List of mood entries"}
    }
)
async def get_mood_history(
    start_date: Optional[str] = Query(
        None, 
        description="Start date (YYYY-MM-DD)",
        example="2025-01-01"
    ),
    end_date: Optional[str] = Query(
        None, 
        description="End date (YYYY-MM-DD)",
        example="2025-12-31"
    ),
    limit: int = Query(
        30, 
        ge=1, 
        le=365, 
        description="Maximum number of entries to return (max 365 for full year history)"
    ),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieve mood history with optional date filtering.
    
    - **start_date**: Filter entries from this date (inclusive)
    - **end_date**: Filter entries until this date (inclusive)
    - **limit**: Maximum number of entries to return (1-365)
    
    Returns a list of mood entries sorted by creation date (newest first).
    """
    # Parse dates
    start = datetime.strptime(start_date, "%Y-%m-%d") if start_date else None
    end = datetime.strptime(end_date, "%Y-%m-%d") if end_date else None
    
    # Get mood history
    mood_entries = crud_mood.get_mood_history(
        db=db,
        user_id=current_user.id,
        start_date=start,
        end_date=end,
        limit=limit
    )
    
    # Format response using Mood model
    formatted_entries = [
        Mood(
            id=entry.id,
            user_id=entry.user_id,
            mood=entry.mood,
            notes=entry.notes,
            created_at=entry.created_at
        )
        for entry in mood_entries
    ]
    
    return {'data': formatted_entries}

@router.get(
    "/latest",
    response_model=Optional[Mood],
    summary="Get latest mood",
    description="Retrieve the most recent mood entry for the authenticated user.",
    responses={
        200: {"description": "Latest mood entry found"},
        404: {"description": "No mood entries found"}
    }
)
async def get_latest_mood(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get the most recent mood entry for the authenticated user.
    
    Returns the latest mood entry with its details and timestamp.
    Returns null if no mood entries exist for the user.
    """
    mood_entry = crud_mood.get_latest_mood_entry(db, current_user.id)
    
    if not mood_entry:
        return None
    
    return Mood(
        id=mood_entry.id,
        user_id=mood_entry.user_id,
        mood=mood_entry.mood,
        notes=mood_entry.notes,
        created_at=mood_entry.created_at
    )
