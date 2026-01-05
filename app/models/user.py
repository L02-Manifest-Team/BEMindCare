from sqlalchemy import (
    Column, Integer, String, Boolean, Enum, DateTime, 
    ForeignKey, Float, Text, Index, UniqueConstraint
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from typing import List, Optional

from app.db.base_class import Base

class UserRole(str, enum.Enum):
    PATIENT = "PATIENT"
    DOCTOR = "DOCTOR"

class User(Base):
    __tablename__ = "users"
    __table_args__ = (
        Index('idx_email', 'email'),
        Index('idx_role', 'role'),
        {'sqlite_autoincrement': True}
    )

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    full_name = Column(String(100), nullable=False)
    phone_number = Column(String(20), nullable=True)
    avatar = Column(String(255), nullable=True)
    role = Column(Enum(UserRole), nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    doctor_profile = relationship("DoctorProfile", back_populates="user", uselist=False)
    
    # Appointments where user is a patient
    appointments_as_patient = relationship(
        "Appointment", 
        foreign_keys="[Appointment.patient_id]",
        back_populates="patient",
        lazy="selectin"
    )
    
    # Appointments where user is a doctor
    appointments_as_doctor = relationship(
        "Appointment",
        foreign_keys="[Appointment.doctor_id]",
        back_populates="doctor",
        lazy="selectin"
    )
    
    # Chat relationships
    chat_participants = relationship(
        "ChatParticipant",
        back_populates="user",
        cascade="all, delete-orphan",
        lazy="selectin"
    )
    
    # Messages sent by user
    messages = relationship(
        "Message",
        back_populates="sender",
        cascade="all, delete-orphan",
        lazy="selectin"
    )
    
    # Mood entries
    mood_entries = relationship(
        "MoodEntry",
        back_populates="user",
        cascade="all, delete-orphan",
        lazy="selectin"
    )
    
    # Journal entries
    journal_entries = relationship(
        "JournalEntry",
        back_populates="user",
        cascade="all, delete-orphan",
        lazy="selectin"
    )

class DoctorProfile(Base):
    __tablename__ = "doctor_profiles"
    __table_args__ = (
        Index('idx_specialization', 'specialization'),
        Index('idx_rating', 'rating'),
        {'sqlite_autoincrement': True}
    )

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, unique=True)
    specialization = Column(String(100), nullable=False)
    bio = Column(Text, nullable=True)
    consultation_fee = Column(Float, default=0.0, nullable=False)
    years_of_experience = Column(Integer, default=0, nullable=False)
    rating = Column(Float, default=0.0, nullable=False)
    review_count = Column(Integer, default=0, nullable=False)

    # Relationships using string references
    user = relationship("User", back_populates="doctor_profile")
    education = relationship("DoctorEducation", back_populates="doctor", cascade="all, delete-orphan")
    experience = relationship("DoctorExperience", back_populates="doctor", cascade="all, delete-orphan")
    available_slots = relationship(
        "app.models.appointment.DoctorAvailability", 
        back_populates="doctor",
        cascade="all, delete-orphan"
    )

class DoctorEducation(Base):
    __tablename__ = "doctor_education"
    __table_args__ = (
        Index('idx_doctor_edu', 'doctor_id', 'year'),
        {'sqlite_autoincrement': True}
    )

    id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(Integer, ForeignKey("doctor_profiles.id", ondelete="CASCADE"), nullable=False)
    degree = Column(String(100), nullable=False)
    university = Column(String(255), nullable=False)
    year = Column(Integer, nullable=False)

    # Relationships
    doctor = relationship("DoctorProfile", back_populates="education")

class DoctorExperience(Base):
    __tablename__ = "doctor_experience"
    __table_args__ = (
        Index('idx_doctor_exp', 'doctor_id', 'start_year'),
        {'sqlite_autoincrement': True}
    )

    id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(Integer, ForeignKey("doctor_profiles.id", ondelete="CASCADE"), nullable=False)
    position = Column(String(100), nullable=False)
    hospital = Column(String(255), nullable=False)
    start_year = Column(Integer, nullable=False)
    end_year = Column(Integer, nullable=True)
    is_current = Column(Boolean, default=False, nullable=False)

    # Relationships
    doctor = relationship("DoctorProfile", back_populates="experience")
