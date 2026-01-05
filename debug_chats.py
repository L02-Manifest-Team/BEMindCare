import sys
import os
sys.path.append(os.getcwd())

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
from app.models.chat import Chat, ChatParticipant, Message
from app.models.user import User

engine = create_engine(settings.DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

with open("debug_result.txt", "w", encoding="utf-8") as f:
    f.write("-" * 50 + "\n")
    f.write("DEBUGGING CHATS AND PARTICIPANTS\n")
    f.write("-" * 50 + "\n")

    # List all users
    f.write(f"\nUsers:\n")
    users = db.query(User).all()
    for u in users:
        f.write(f"ID: {u.id}, Email: {u.email}, Role: {u.role}, Name: {u.full_name}\n")

    # List all chats
    f.write(f"\nChats:\n")
    chats = db.query(Chat).all()
    for c in chats:
        f.write(f"Chat ID: {c.id}, Created At: {c.created_at}\n")
        
        # Participants
        participants = db.query(ChatParticipant).filter(ChatParticipant.chat_id == c.id).all()
        f.write(f"  Participants ({len(participants)}):\n")
        for p in participants:
            user = db.query(User).filter(User.id == p.user_id).first()
            role = user.role if user else 'Unknown'
            f.write(f"    - User ID: {p.user_id} ({role})\n")
        
        # Messages count
        msg_count = db.query(Message).filter(Message.chat_id == c.id).count()
        f.write(f"  Messages: {msg_count}\n")
        
        # Last message
        last_msg = db.query(Message).filter(Message.chat_id == c.id).order_by(Message.created_at.desc()).first()
        if last_msg:
            f.write(f"  Last Message: '{last_msg.content}' from User {last_msg.sender_id}\n")

    f.write("-" * 50 + "\n")
print("Done writing to debug_result.txt")
