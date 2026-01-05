from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime

from app.models.journal import JournalEntry

def create_journal_entry(
    db: Session,
    user_id: int,
    content: str,
    title: Optional[str] = None
) -> JournalEntry:
    """Create a new journal entry."""
    journal = JournalEntry(
        user_id=user_id,
        content=content,
        title=title
    )
    db.add(journal)
    db.commit()
    db.refresh(journal)
    return journal

def get_journal_entries(
    db: Session,
    user_id: int,
    skip: int = 0,
    limit: int = 50
) -> List[JournalEntry]:
    """Get journal entries for a user."""
    return db.query(JournalEntry).filter(
        JournalEntry.user_id == user_id
    ).order_by(JournalEntry.created_at.desc()).offset(skip).limit(limit).all()

def get_journal_entry(
    db: Session,
    journal_id: int,
    user_id: int
) -> Optional[JournalEntry]:
    """Get a specific journal entry."""
    return db.query(JournalEntry).filter(
        JournalEntry.id == journal_id,
        JournalEntry.user_id == user_id
    ).first()

def update_journal_entry(
    db: Session,
    journal_id: int,
    user_id: int,
    content: Optional[str] = None,
    title: Optional[str] = None
) -> Optional[JournalEntry]:
    """Update a journal entry."""
    journal = get_journal_entry(db, journal_id, user_id)
    if journal:
        if content is not None:
            journal.content = content
        if title is not None:
            journal.title = title
        journal.updated_at = datetime.utcnow()
        db.commit()
        db.refresh(journal)
    return journal

def delete_journal_entry(
    db: Session,
    journal_id: int,
    user_id: int
) -> bool:
    """Delete a journal entry."""
    journal = get_journal_entry(db, journal_id, user_id)
    if journal:
        db.delete(journal)
        db.commit()
        return True
    return False

def count_journal_entries(db: Session, user_id: int) -> int:
    """Count total journal entries for a user."""
    return db.query(JournalEntry).filter(JournalEntry.user_id == user_id).count()
