from sqlalchemy import create_engine, event
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import types
from datetime import datetime, time
from dateutil import tz
from app.core.config import settings

# Tạo engine kết nối đến cơ sở dữ liệu
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    pool_recycle=3600,
    connect_args={"connect_timeout": 10}
)

# Tạo session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Hàm chuyển đổi datetime từ database
@event.listens_for(engine, 'before_cursor_execute')
def receive_before_cursor_execute(conn, cursor, statement, params, context, executemany):
    if params is not None:
        if isinstance(params, dict):
            for key, value in params.items():
                if isinstance(value, str):
                    try:
                        if ' ' in value and ':' in value:
                            # Handle datetime
                            dt = datetime.strptime(value, '%Y-%m-%d %H:%M:%S')
                            local_tz = tz.gettz('Asia/Ho_Chi_Minh')
                            dt = dt.replace(tzinfo=local_tz)
                            params[key] = dt
                        elif ':' in value and value.count(':') < 3:
                            # Handle time only
                            t = datetime.strptime(value, '%H:%M:%S').time()
                            params[key] = t
                    except (ValueError, TypeError):
                        pass
        elif isinstance(params, (list, tuple)):
            new_params = []
            for param in params:
                if isinstance(param, str):
                    try:
                        if ' ' in param and ':' in param:
                            # Handle datetime
                            dt = datetime.strptime(param, '%Y-%m-%d %H:%M:%S')
                            local_tz = tz.gettz('Asia/Ho_Chi_Minh')
                            dt = dt.replace(tzinfo=local_tz)
                            new_params.append(dt)
                        elif ':' in param and param.count(':') < 3:
                            # Handle time only
                            t = datetime.strptime(param, '%H:%M:%S').time()
                            new_params.append(t)
                        else:
                            new_params.append(param)
                    except (ValueError, TypeError):
                        new_params.append(param)
                else:
                    new_params.append(param)
            context._parameters = tuple(new_params) if isinstance(params, tuple) else new_params

# Base class cho các model
Base = declarative_base()

def get_db():
    """
    Dependency để lấy database session.
    Sử dụng trong các endpoint cần tương tác với database.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
