from fastapi import APIRouter

# Tạo router chính
router = APIRouter()

# Import các router con
from . import auth, doctors, appointments, chat, mood, journal

# Đăng ký các router con
router.include_router(auth.router, tags=["Authentication"])
router.include_router(doctors.router, prefix="/doctors", tags=["Doctors"])
router.include_router(appointments.router, prefix="/appointments", tags=["Appointments"])
router.include_router(chat.router, prefix="/chats", tags=["Chats"])
router.include_router(mood.router, prefix="/mood", tags=["Mood Tracking"])
router.include_router(journal.router, prefix="/journal", tags=["Journal"])
