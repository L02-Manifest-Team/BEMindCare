from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, date

from app.db.session import get_db
from app.models.appointment import Appointment as AppointmentModel, AppointmentStatus, DoctorAvailability
from app.models.user import User

# Import schemas
from app.schemas.appointment import (
    AppointmentCreate,
    Appointment as AppointmentResponse,
    AppointmentUpdate,
    AppointmentListResponse,
    AppointmentWithRelations
)

# Import security and user schemas
from app.core.security import get_current_user
from app.schemas.user import UserBase

router = APIRouter()

@router.post("/", response_model=AppointmentResponse, status_code=status.HTTP_201_CREATED)
def create_appointment(
    appointment_in: AppointmentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Kiểm tra bác sĩ có tồn tại không
    doctor = db.query(User).filter(
        User.id == appointment_in.doctor_id,
        User.role == "DOCTOR"
    ).first()
    
    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    
    # Kiểm tra xem bác sĩ có khả dụng vào khung giờ này không
    availability = db.query(DoctorAvailability).filter(
        DoctorAvailability.doctor_id == appointment_in.doctor_id,
        DoctorAvailability.date == appointment_in.appointment_date,
        DoctorAvailability.time_slot == appointment_in.time_slot,
        DoctorAvailability.is_available == True
    ).first()
    
    if not availability:
        raise HTTPException(status_code=400, detail="Doctor is not available at this time slot")
    
    # Kiểm tra xem bệnh nhân đã có lịch hẹn nào trùng khung giờ này chưa
    existing_appointment = db.query(AppointmentModel).filter(
        AppointmentModel.patient_id == current_user.id,
        AppointmentModel.appointment_date == appointment_in.appointment_date,
        AppointmentModel.time_slot == appointment_in.time_slot,
        AppointmentModel.status.in_(["PENDING", "CONFIRMED"])
    ).first()
    
    if existing_appointment:
        raise HTTPException(status_code=400, detail="You already have an appointment at this time")
    
    # Tạo lịch hẹn mới
    db_appointment = AppointmentModel(
        **appointment_in.dict(),
        patient_id=current_user.id,
        status=AppointmentStatus.PENDING
    )
    
    # Đánh dấu khung giờ này là đã đặt
    availability.is_available = False
    
    db.add(db_appointment)
    db.commit()
    db.refresh(db_appointment)
    
    return AppointmentResponse.from_orm(db_appointment)

@router.get("/", response_model=AppointmentListResponse)
def get_appointments(
    status: Optional[str] = None,
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Xây dựng query cơ bản
    if current_user.role == "PATIENT":
        query = db.query(AppointmentModel).filter(AppointmentModel.patient_id == current_user.id)
    else:  # DOCTOR
        query = db.query(AppointmentModel).filter(AppointmentModel.doctor_id == current_user.id)
    

    # Áp dụng bộ lọc
    if status:
        query = query.filter(AppointmentModel.status == status)
    if start_date:
        query = query.filter(AppointmentModel.appointment_date >= start_date)
    if end_date:
        query = query.filter(AppointmentModel.appointment_date <= end_date)
    
    # Phân trang
    total = query.count()
    offset = (page - 1) * limit
    appointments = query.offset(offset).limit(limit).all()
    
    # Chuyển đổi sang schema
    appointment_list = []
    for appt in appointments:
        # Lấy thông tin bác sĩ và bệnh nhân
        doctor = db.query(User).filter(User.id == appt.doctor_id).first()
        patient = db.query(User).filter(User.id == appt.patient_id).first()
        
        appt_with_relations = AppointmentWithRelations(
            **appt.__dict__,
            doctor=UserBase.from_orm(doctor),
            patient=UserBase.from_orm(patient)
        )
        appointment_list.append(appt_with_relations)
    
    return AppointmentListResponse(data=appointment_list, pagination={
        "total": total,
        "page": page,
        "limit": limit,
        "total_pages": (total + limit - 1) // limit
    })

@router.get("/{appointment_id}", response_model=AppointmentWithRelations)
def get_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    appointment = db.query(AppointmentModel).filter(AppointmentModel.id == appointment_id).first()
    
    if not appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")
    
    # Kiểm tra quyền truy cập
    if current_user.role == "PATIENT" and appointment.patient_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to view this appointment")
    if current_user.role == "DOCTOR" and appointment.doctor_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to view this appointment")
    
    # Lấy thông tin bác sĩ và bệnh nhân
    doctor = db.query(User).filter(User.id == appointment.doctor_id).first()
    patient = db.query(User).filter(User.id == appointment.patient_id).first()
    
    return AppointmentWithRelations(
        **{c.name: getattr(appointment, c.name) for c in appointment.__table__.columns},
        doctor=UserBase.from_orm(doctor),
        patient=UserBase.from_orm(patient)
    )

@router.put("/{appointment_id}", response_model=AppointmentResponse)
def update_appointment(
    appointment_id: int,
    appointment_update: AppointmentUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_appointment = db.query(AppointmentModel).filter(AppointmentModel.id == appointment_id).first()
    
    if not db_appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")
    
    # Kiểm tra quyền chỉnh sửa
    if current_user.role == "PATIENT" and db_appointment.patient_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this appointment")
    if current_user.role == "DOCTOR" and db_appointment.doctor_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this appointment")
    
    # Cập nhật thông tin cuộc hẹn
    update_data = appointment_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_appointment, field, value)
    
    db.commit()
    db.refresh(db_appointment)
    
    return AppointmentResponse.from_orm(db_appointment)

@router.delete("/{appointment_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_appointment = db.query(AppointmentModel).filter(AppointmentModel.id == appointment_id).first()
    
    if not db_appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")
    
    # Kiểm tra quyền xóa
    if current_user.role == "PATIENT" and db_appointment.patient_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this appointment")
    if current_user.role == "DOCTOR" and db_appointment.doctor_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this appointment")
    
    # Nếu là bệnh nhân, chỉ được hủy nếu chưa được xác nhận
    if current_user.role == "PATIENT" and db_appointment.status == "CONFIRMED":
        raise HTTPException(status_code=400, detail="Cannot delete a confirmed appointment. Please contact the clinic.")
    
    # Nếu là bác sĩ, đánh dấu lịch hẹn là đã hủy thay vì xóa
    if current_user.role == "DOCTOR":
        db_appointment.status = "CANCELLED"
        db.commit()
        db.refresh(db_appointment)
    else:
        # Nếu là bệnh nhân, xóa lịch hẹn
        db.delete(db_appointment)
        db.commit()
    
    return None
