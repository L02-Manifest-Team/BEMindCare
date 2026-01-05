# Script to create journal_entries table
from app.models import JournalEntry
from app.db.session import engine, Base

if __name__ == "__main__":
    print("Creating journal_entries table...")
    Base.metadata.create_all(bind=engine)
    print("Done! Table journal_entries created successfully.")
