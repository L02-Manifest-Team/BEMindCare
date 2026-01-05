# Import order matters - import base first
from app.db.base_class import Base

# Import all models to ensure they are registered with SQLAlchemy
from .user import User, UserRole, DoctorProfile, DoctorEducation, DoctorExperience
from .appointment import Appointment, AppointmentStatus, DoctorAvailability
from .chat import Chat, ChatParticipant, Message
from .mood import MoodEntry, MoodType
from .journal import JournalEntry

# This ensures that all models are properly imported and registered with SQLAlchemy
# before any relationships are set up
__all__ = [
    'Base',
    'User', 
    'UserRole', 
    'DoctorProfile', 
    'DoctorEducation', 
    'DoctorExperience',
    'Chat',
    'ChatParticipant',
    'Message',
    'MoodEntry',
    'MoodType',
    'Appointment',
    'AppointmentStatus',
    'DoctorAvailability',
    'JournalEntry'
]
