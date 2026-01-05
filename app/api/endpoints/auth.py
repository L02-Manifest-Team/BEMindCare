from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from typing import Any

from app.core.security import (
    create_access_token, 
    create_refresh_token, 
    get_password_hash, 
    verify_password,
    get_current_user,
    get_current_active_user
)
from app.schemas.user import Token, LoginRequest, UserCreate, User
from pydantic import BaseModel
from app.db.session import get_db
from app.models.user import User as UserModel
from app.core.config import settings

router = APIRouter()

@router.post("/register", response_model=User)
async def register(user_in: UserCreate, db: Session = Depends(get_db)):
    # Check if user already exists
    db_user = db.query(UserModel).filter(UserModel.email == user_in.email).first()
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Create new user
    hashed_password = get_password_hash(user_in.password)
    db_user = UserModel(
        email=user_in.email,
        hashed_password=hashed_password,
        full_name=user_in.full_name,
        phone_number=user_in.phone_number,
        role=user_in.role
    )
    
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return db_user

@router.post("/login", response_model=Token)
async def login(login_data: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(UserModel).filter(UserModel.email == login_data.email).first()
    if not user or not verify_password(login_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Inactive user"
        )
    
    # Create tokens
    access_token = create_access_token(subject=user.email)
    refresh_token = create_refresh_token(subject=user.email)
    
    # Return Token model to ensure refresh_token is included
    # Use model_dump with exclude_none=False to ensure refresh_token is always included
    token_response = Token(
        access_token=access_token,
        token_type="bearer",
        refresh_token=refresh_token
    )
    # Return as dict to bypass FastAPI's response_model serialization which might exclude None
    # But we still validate with response_model=Token
    return token_response.model_dump(exclude_none=False)

@router.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = db.query(UserModel).filter(UserModel.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token = create_access_token(subject=user.email)
    refresh_token = create_refresh_token(subject=user.email)
    
    # Return Token model to ensure refresh_token is included
    # Use model_dump with exclude_none=False to ensure refresh_token is always included
    token_response = Token(
        access_token=access_token,
        token_type="bearer",
        refresh_token=refresh_token
    )
    # Return as dict to bypass FastAPI's response_model serialization which might exclude None
    # But we still validate with response_model=Token
    return token_response.model_dump(exclude_none=False)

class RefreshTokenRequest(BaseModel):
    refresh_token: str

@router.post("/refresh", response_model=Token)
async def refresh_token(
    refresh_data: RefreshTokenRequest,
    db: Session = Depends(get_db)
):
    """
    Refresh access token using refresh token.
    """
    from jose import jwt
    from app.core.config import settings
    
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate refresh token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(
            refresh_data.refresh_token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        # Check if it's a refresh token
        if payload.get("type") != "refresh":
            raise credentials_exception
        
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except jwt.JWTError:
        raise credentials_exception
    
    # Get user
    user = db.query(UserModel).filter(UserModel.email == username).first()
    if user is None or not user.is_active:
        raise credentials_exception
    
    # Create new tokens
    new_access_token = create_access_token(subject=user.email)
    new_refresh_token = create_refresh_token(subject=user.email)
    
    # Return Token model to ensure refresh_token is included
    # Use model_dump with exclude_none=False to ensure refresh_token is always included
    token_response = Token(
        access_token=new_access_token,
        token_type="bearer",
        refresh_token=new_refresh_token
    )
    # Return as dict to bypass FastAPI's response_model serialization which might exclude None
    # But we still validate with response_model=Token
    return token_response.model_dump(exclude_none=False)

@router.get("/me", response_model=User)
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user
