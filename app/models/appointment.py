from sqlalchemy import (
    Column, Integer, String, DateTime, ForeignKey, 
    Enum as SQLEnum, Boolean, Date, Index
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from typing import Optional

from app.db.base_class import Base

class AppointmentStatus(str, enum.Enum):
    PENDING = "PENDING"
    CONFIRMED = "CONFIRMED"
    COMPLETED = "COMPLETED"
    CANCELLED = "CANCELLED"

class Appointment(Base):
    __tablename__ = "appointments"
    __table_args__ = (
        Index('idx_appointment_date', 'appointment_date'),
        Index('idx_status', 'status'),
        Index('idx_doctor_appointment', 'doctor_id', 'appointment_date'),
        Index('idx_patient_appointment', 'patient_id', 'appointment_date'),
    )

    id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    patient_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    appointment_date = Column(Date, nullable=False)
    time_slot = Column(String(50), nullable=False)
    status = Column(SQLEnum(AppointmentStatus), default=AppointmentStatus.PENDING, nullable=False)
    reason = Column(String, nullable=False)
    notes = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    doctor = relationship(
        "User",
        foreign_keys=[doctor_id],
        back_populates="appointments_as_doctor"
    )
    
    patient = relationship(
        "User",
        foreign_keys=[patient_id],
        back_populates="appointments_as_patient"
    )

class DoctorAvailability(Base):
    __tablename__ = "doctor_availability"
    __table_args__ = (
        Index('idx_availability', 'doctor_id', 'date', 'is_available'),
        {'sqlite_autoincrement': True}
    )

    id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(Integer, ForeignKey("doctor_profiles.id", ondelete="CASCADE"), nullable=False)
    date = Column(Date, nullable=False)
    time_slot = Column(String(50), nullable=False)
    is_available = Column(Boolean, default=True, nullable=False)

    # Relationship with DoctorProfile
    doctor = relationship(
        "DoctorProfile",
        back_populates="available_slots"
    )
