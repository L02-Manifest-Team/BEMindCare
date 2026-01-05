from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum

class UserRole(str, Enum):
    PATIENT = "PATIENT"
    DOCTOR = "DOCTOR"

# Base schemas
class UserBase(BaseModel):
    email: EmailStr
    full_name: str
    phone_number: Optional[str] = None
    avatar: Optional[str] = None
    
    class Config:
        from_attributes = True

# For creating new user
class UserCreate(UserBase):
    password: str = Field(..., min_length=6, max_length=72, description="Password must be between 6 and 72 characters")
    role: UserRole

# For updating user
class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None
    phone_number: Optional[str] = None
    avatar: Optional[str] = None

# For returning user data
class UserInDBBase(UserBase):
    id: int
    role: UserRole
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class User(UserInDBBase):
    pass

# Auth schemas
class Token(BaseModel):
    access_token: str
    token_type: str
    refresh_token: Optional[str] = None
    
    class Config:
        # Ensure refresh_token is included in response even if None
        json_encoders = {
            str: str
        }
        # Use model_dump with exclude_none=False to include None values
        # But we want to exclude None, so we'll handle it in the endpoint

class TokenData(BaseModel):
    email: Optional[str] = None

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

# Doctor specific schemas
class DoctorEducationBase(BaseModel):
    degree: str
    university: str
    year: int

class DoctorExperienceBase(BaseModel):
    position: str
    hospital: str
    start_year: int
    end_year: Optional[int] = None
    current: bool = False

class DoctorProfileBase(BaseModel):
    specialization: str
    bio: Optional[str] = None
    consultation_fee: float = 0.0
    years_of_experience: int = 0

class DoctorProfileCreate(DoctorProfileBase):
    education: List[DoctorEducationBase] = []
    experience: List[DoctorExperienceBase] = []

class DoctorProfile(DoctorProfileBase):
    id: int
    user_id: int
    rating: float = 0.0
    review_count: int = 0
    education: List[DoctorEducationBase] = []
    experience: List[DoctorExperienceBase] = []

    class Config:
        from_attributes = True

class DoctorPublic(UserInDBBase):
    doctor_profile: Optional[DoctorProfile] = None

class DoctorListResponse(BaseModel):
    data: List[DoctorPublic]
    pagination: dict

# For doctor availability
class TimeSlot(BaseModel):
    time: str  # HH:MM
    is_available: bool = True

class DoctorAvailability(BaseModel):
    date: str  # YYYY-MM-DD
    time_slots: List[TimeSlot]
