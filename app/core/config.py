from pydantic_settings import BaseSettings
from typing import Optional
import os

class Settings(BaseSettings):
    PROJECT_NAME: str = "BEMindCare API"
    API_V1_STR: str = "/api"
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-secret-key-here-change-in-production")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 ngày
    ALGORITHM: str = "HS256"
    
    # Database - Railway MySQL requires pymysql driver and SSL
    # Read from environment variable first, fallback to default for local dev
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL",
        "mysql+pymysql://root:kBXpNkNZrMwQHpKkZTAdmhXFWDIrkOqa"
        "@yamanote.proxy.rlwy.net:38903/railway"
        "?charset=utf8mb4&ssl=true"
    )
    
    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()
