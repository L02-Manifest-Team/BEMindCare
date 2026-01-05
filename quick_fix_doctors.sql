-- Quick verification and fix script
-- Run this in MySQL Workbench

USE `bkmindcare`;

-- Check current state
SELECT 'USERS' as TableName, COUNT(*) as Count FROM users
UNION SELECT 'DOCTORS', COUNT(*) FROM users WHERE role = 'DOCTOR'
UNION SELECT 'DOCTOR_PROFILES', COUNT(*) FROM doctor_profiles;

-- If doctor_profiles is 0, manually insert them
INSERT INTO doctor_profiles (user_id, specialization, bio, consultation_fee, years_of_experience, rating, review_count)
SELECT 
    id,
    'Tâm lý học lâm sàng',
    'Chuyên gia tâm lý với nhiều năm kinh nghiệm',
    500000,
    10,
    4.8,
    100
FROM users 
WHERE role = 'DOCTOR'
AND id NOT IN (SELECT user_id FROM doctor_profiles);

-- Verify again
SELECT 'After Insert - DOCTOR_PROFILES' as Info, COUNT(*) as Count FROM doctor_profiles;
