from pydantic import BaseModel, Field
from datetime import datetime, date
from typing import Optional, List
from enum import Enum

class AppointmentStatus(str, Enum):
    PENDING = "PENDING"
    CONFIRMED = "CONFIRMED"
    COMPLETED = "COMPLETED"
    CANCELLED = "CANCELLED"

class AppointmentBase(BaseModel):
    doctor_id: int
    appointment_date: str  # YYYY-MM-DD
    time_slot: str  # HH:MM
    reason: str
    notes: Optional[str] = None

class AppointmentCreate(AppointmentBase):
    pass

class AppointmentUpdate(BaseModel):
    status: Optional[AppointmentStatus] = None
    reason: Optional[str] = None
    notes: Optional[str] = None

class AppointmentInDBBase(AppointmentBase):
    id: int
    patient_id: int
    status: AppointmentStatus
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
        # Use json_encoders to handle date conversion
        json_encoders = {
            date: lambda v: v.isoformat() if isinstance(v, date) else v
        }

class Appointment(AppointmentInDBBase):
    pass

class AppointmentWithRelations(Appointment):
    doctor: 'UserBase'
    patient: 'UserBase'

class AppointmentListResponse(BaseModel):
    data: List[AppointmentWithRelations]
    pagination: dict

# Import UserBase here to avoid circular imports
from app.schemas.user import UserBase
AppointmentWithRelations.update_forward_refs()
