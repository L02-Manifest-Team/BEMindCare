import sys
sys.path.insert(0, '.')

from app.db.session import engine
from sqlalchemy import text

# Check doctor_profiles count
with engine.connect() as conn:
    result = conn.execute(text('SELECT COUNT(*) as cnt FROM doctor_profiles')).first()
    print(f'Doctor profiles count: {result[0]}')
    
    # Get users with DOCTOR role
    doctors = conn.execute(text("SELECT id, full_name, role FROM users WHERE role = 'DOCTOR'")).fetchall()
    print(f'\nDoctors in users table: {len(doctors)}')
    for d in doctors:
        print(f'  - ID {d[0]}: {d[1]} ({d[2]})')
    
    # Check which doctors have profiles
    profiles = conn.execute(text('SELECT user_id, specialization FROM doctor_profiles')).fetchall()
    print(f'\nDoctor profiles: {len(profiles)}')
    for p in profiles:
        print(f'  - User ID {p[0]}: {p[1]}')
