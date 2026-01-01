from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from app.db.session import get_db
from app.models.user import User, DoctorProfile, DoctorEducation, DoctorExperience, UserRole
from app.schemas.user import DoctorPublic, DoctorListResponse, DoctorProfileCreate, DoctorEducationBase, DoctorExperienceBase
from app.core.security import get_current_user
from app.schemas.user import User as UserSchema

router = APIRouter()

@router.get("/", response_model=DoctorListResponse)
async def get_doctors(
    specialization: Optional[str] = None,
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    sort: Optional[str] = None,
    order: str = "desc",
    db: Session = Depends(get_db)
):
    # Xây dựng query cơ bản
    query = db.query(User).join(DoctorProfile, User.id == DoctorProfile.user_id)
    
    # Lọc theo chuyên khoa nếu có
    if specialization:
        query = query.filter(DoctorProfile.specialization.ilike(f"%{specialization}%"))
    
    # Sắp xếp
    if sort == "rating":
        if order == "asc":
            query = query.order_by(DoctorProfile.rating.asc())
        else:
            query = query.order_by(DoctorProfile.rating.desc())
    elif sort == "appointmentCount":
        # Giả sử có trường appointment_count trong bác sĩ
        if order == "asc":
            query = query.order_by(DoctorProfile.appointment_count.asc())
        else:
            query = query.order_by(DoctorProfile.appointment_count.desc())
    else:
        # Mặc định sắp xếp theo tên
        if order == "asc":
            query = query.order_by(User.full_name.asc())
        else:
            query = query.order_by(User.full_name.desc())
    
    # Phân trang
    total = query.count()
    offset = (page - 1) * limit
    doctors = query.offset(offset).limit(limit).all()
    
    # Chuyển đổi sang schema
    doctor_list = []
    for doctor in doctors:
        doctor_public = DoctorPublic(
            **UserSchema.from_orm(doctor).dict(),
            doctor_profile=doctor.doctor_profile
        )
        doctor_list.append(doctor_public)
    
    return {
        "data": doctor_list,
        "pagination": {
            "total": total,
            "page": page,
            "limit": limit,
            "total_pages": (total + limit - 1) // limit
        }
    }

@router.get("/{doctor_id}", response_model=DoctorPublic)
async def get_doctor(doctor_id: int, db: Session = Depends(get_db)):
    # Tìm bác sĩ theo ID
    doctor = db.query(User).join(DoctorProfile).filter(User.id == doctor_id).first()
    
    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    
    # Lấy thông tin chi tiết bác sĩ
    doctor_public = DoctorPublic(
        **UserSchema.from_orm(doctor).dict(),
        doctor_profile=doctor.doctor_profile
    )
    
    return doctor_public

@router.post("/{doctor_id}/availability")
async def add_doctor_availability(
    doctor_id: int,
    availability: List[dict],
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Chỉ có bác sĩ mới được thêm lịch làm việc
    # if current_user.role != UserRole.DOCTOR or current_user.id != doctor_id:
    #     raise HTTPException(status_code=403, detail="Not enough permissions")
    


    # Xóa lịch cũ nếu có
    db.query(DoctorAvailability).filter(DoctorAvailability.doctor_id == doctor_id).delete()
    
    # Thêm lịch mới
    for slot in availability:
        db_slot = DoctorAvailability(
            doctor_id=doctor_id,
            date=slot["date"],
            time_slot=slot["time_slot"],
            is_available=slot.get("is_available", True)
        )
        db.add(db_slot)
    
    db.commit()
    return {"message": "Doctor availability updated successfully"}
