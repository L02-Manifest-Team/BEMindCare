from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional

from app.db.session import get_db
from app.models.user import User
from app.crud import journal as crud_journal
from app.schemas.journal import JournalCreate, JournalUpdate, JournalResponse, JournalListResponse
from app.core.security import get_current_user

router = APIRouter(
    prefix="",
    tags=["Journal"],
    responses={
        401: {"description": "Unauthorized"},
        404: {"description": "Not found"},
        422: {"description": "Validation Error"}
    }
)

@router.post(
    "/",
    response_model=JournalResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create journal entry",
    description="Create a new personal journal entry."
)
async def create_journal(
    journal_in: JournalCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new journal entry for the authenticated user."""
    journal = crud_journal.create_journal_entry(
        db=db,
        user_id=current_user.id,
        content=journal_in.content,
        title=journal_in.title
    )
    return journal

@router.get(
    "/",
    response_model=JournalListResponse,
    summary="Get journal entries",
    description="Get all journal entries for the authenticated user."
)
async def get_journals(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all journal entries for the authenticated user."""
    entries = crud_journal.get_journal_entries(
        db=db,
        user_id=current_user.id,
        skip=skip,
        limit=limit
    )
    total = crud_journal.count_journal_entries(db, current_user.id)
    return JournalListResponse(data=entries, total=total)

@router.get(
    "/{journal_id}",
    response_model=JournalResponse,
    summary="Get journal entry",
    description="Get a specific journal entry by ID."
)
async def get_journal(
    journal_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific journal entry."""
    journal = crud_journal.get_journal_entry(db, journal_id, current_user.id)
    if not journal:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Journal entry not found"
        )
    return journal

@router.put(
    "/{journal_id}",
    response_model=JournalResponse,
    summary="Update journal entry",
    description="Update a specific journal entry."
)
async def update_journal(
    journal_id: int,
    journal_in: JournalUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update a journal entry."""
    journal = crud_journal.update_journal_entry(
        db=db,
        journal_id=journal_id,
        user_id=current_user.id,
        content=journal_in.content,
        title=journal_in.title
    )
    if not journal:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Journal entry not found"
        )
    return journal

@router.delete(
    "/{journal_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete journal entry",
    description="Delete a specific journal entry."
)
async def delete_journal(
    journal_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete a journal entry."""
    success = crud_journal.delete_journal_entry(db, journal_id, current_user.id)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Journal entry not found"
        )
    return None
