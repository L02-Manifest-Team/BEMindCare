from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.core.config import settings
from app.api.endpoints import auth, doctors, appointments, chat, mood, journal
from app.db.session import engine, Base

# Tạo bảng trong cơ sở dữ liệu
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="API for BEMindCare - Mental Health Consultation Platform",
    version="1.0.0"
)

# Cấu hình CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Đăng ký các router
app.include_router(
    auth.router,
    prefix=f"{settings.API_V1_STR}/auth",
    tags=["Authentication"]
)

app.include_router(
    doctors.router,
    prefix=f"{settings.API_V1_STR}/doctors",
    tags=["Doctors"]
)

app.include_router(
    appointments.router,
    prefix=f"{settings.API_V1_STR}/appointments",
    tags=["Appointments"]
)

app.include_router(
    chat.router,
    prefix=f"{settings.API_V1_STR}/chats",
    tags=["Chats"]
)

app.include_router(
    mood.router,
    prefix=f"{settings.API_V1_STR}/mood",
    tags=["Mood Tracking"]
)

app.include_router(
    journal.router,
    prefix=f"{settings.API_V1_STR}/journal",
    tags=["Journal"]
)

@app.get("/")
async def root():
    return {
        "message": "Welcome to BEMindCare API",
        "docs": "/docs",
        "redoc": "/redoc"
    }

@app.get("/api/health")
async def health_check():
    """Health check endpoint for Railway and monitoring"""
    return {"status": "ok", "service": "BKMindCare API"}


if __name__ == "__main__":
    import uvicorn
    import os
    
    # Railway provides PORT via environment variable
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("app.main:app", host="0.0.0.0", port=port, reload=False)

