from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "BEMindCare API"
    API_V1_STR: str = "/api"
    SECRET_KEY: str = "your-secret-key-here"  # Thay đổi trong môi trường production
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 ngày
    ALGORITHM: str = "HS256"
    
    # Database
    DATABASE_URL: str = "mysql://root:root@localhost:3306/bemindcare?charset=utf8mb4"
    
    class Config:
        case_sensitive = True

settings = Settings()
