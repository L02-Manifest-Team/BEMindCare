from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "BEMindCare API"
    API_V1_STR: str = "/api"
    SECRET_KEY: str = "your-secret-key-here"  # Thay đổi trong môi trường production
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 ngày
    ALGORITHM: str = "HS256"
    
    # Database - Railway MySQL requires pymysql driver and SSL
    DATABASE_URL: str = (
        "mysql+pymysql://root:kBXpNkNZrMwQHpKkZTAdmhXFWDIrkOqa"
        "@yamanote.proxy.rlwy.net:38903/railway"
        "?charset=utf8mb4&ssl=true"
    )
    
    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()
