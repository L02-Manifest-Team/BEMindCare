import sys
import os
sys.path.append(os.getcwd())

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
from app.models.chat import Chat, ChatParticipant, Message
from app.models.user import User

engine = create_engine(settings.SQLALCHEMY_DATABASE_URI)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

print("-" * 50)
print("DEBUGGING CHATS AND PARTICIPANTS")
print("-" * 50)

# List all users
print(f"\nUsers:")
users = db.query(User).all()
for u in users:
    print(f"ID: {u.id}, Email: {u.email}, Role: {u.role}, Name: {u.full_name}")

# List all chats
print(f"\nChats:")
chats = db.query(Chat).all()
for c in chats:
    print(f"Chat ID: {c.id}, Created At: {c.created_at}")
    
    # Participants
    participants = db.query(ChatParticipant).filter(ChatParticipant.chat_id == c.id).all()
    print(f"  Participants ({len(participants)}):")
    for p in participants:
        user = db.query(User).filter(User.id == p.user_id).first()
        print(f"    - User ID: {p.user_id} ({user.role if user else 'Unknown'})")
    
    # Messages count
    msg_count = db.query(Message).filter(Message.chat_id == c.id).count()
    print(f"  Messages: {msg_count}")
    
    # Last message
    last_msg = db.query(Message).filter(Message.chat_id == c.id).order_by(Message.created_at.desc()).first()
    if last_msg:
        print(f"  Last Message: '{last_msg.content}' from User {last_msg.sender_id}")

print("-" * 50)
