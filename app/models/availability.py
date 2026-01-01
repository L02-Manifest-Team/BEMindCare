from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Boolean, Time, Date, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.base_class import Base

class DoctorAvailability(Base):
    __tablename__ = "doctor_availability"
    
    id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(Integer, ForeignKey("doctor_profiles.id"), nullable=False)
    day_of_week = Column(Integer, nullable=False)  # 0-6 (Monday-Sunday)
    start_time = Column(Time, nullable=False)
    end_time = Column(Time, nullable=False)
    is_available = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships using string references
    doctor = relationship("app.models.user.DoctorProfile", back_populates="available_slots")
