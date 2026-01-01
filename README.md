# BEMindCare - Mental Health Consultation Platform

Backend API for BEMindCare, a platform connecting patients with mental health professionals.

## Công nghệ sử dụng

- Python 3.8+
- FastAPI
- SQLAlchemy (ORM)
- PostgreSQL
- JWT Authentication
- Pydantic

## Cài đặt

1. Tạo và kích hoạt môi trường ảo:
```bash
python -m venv venv
source venv/bin/activate  # Trên Windows: .\\venv\\Scripts\\activate
```

2. Cài đặt các thư viện cần thiết:
```bash
pip install -r requirements.txt
```

3. Tạo file .env từ file .env.example và cấu hình các biến môi trường cần thiết.

<!-- 4. Khởi tạo cơ sở dữ liệu:
```bash
alembic upgrade head
``` -->

4. Chạy ứng dụng:
```bash
uvicorn app.main:app --reload
```

## API Documentation

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Các endpoint chính

### Xác thực người dùng
- `POST /api/auth/register` - Đăng ký tài khoản mới
- `POST /api/auth/login` - Đăng nhập
- `GET /api/auth/me` - Lấy thông tin người dùng hiện tại

### Quản lý bác sĩ
- `GET /api/doctors` - Lấy danh sách bác sĩ
- `GET /api/doctors/{id}` - Lấy thông tin chi tiết bác sĩ

### Quản lý lịch hẹn
- `GET /api/appointments` - Lấy danh sách lịch hẹn
- `POST /api/appointments` - Tạo lịch hẹn mới
- `GET /api/appointments/{id}` - Lấy thông tin chi tiết lịch hẹn
- `PATCH /api/appointments/{id}` - Cập nhật lịch hẹn
- `DELETE /api/appointments/{id}` - Hủy lịch hẹn

## Cấu trúc thư mục

```
app/
├── api/
│   ├── endpoints/
│   │   ├── auth.py
│   │   ├── doctors.py
│   │   └── appointments.py
│   └── __init__.py
├── core/
│   ├── config.py
│   └── security.py
├── db/
│   ├── base.py
│   └── __init__.py
├── models/
│   ├── user.py
│   └── appointment.py
├── schemas/
│   ├── user.py
│   └── appointment.py
├── __init__.py
└── main.py
```

## Giấy phép

MIT
