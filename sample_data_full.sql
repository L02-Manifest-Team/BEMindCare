-- Complete Sample Data for BKMindCare Database
-- Password for all users: minhtien
-- Hashed with pbkdf2-sha256 (matching existing format)

USE `bkmindcare`;

-- Disable safe update mode for this session
SET SQL_SAFE_UPDATES = 0;

-- Clear existing data (in correct order to respect foreign keys)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `messages`;
TRUNCATE TABLE `chat_participants`;
TRUNCATE TABLE `chats`;
TRUNCATE TABLE `mood_entries`;
TRUNCATE TABLE `journal_entries`;
TRUNCATE TABLE `appointments`;
TRUNCATE TABLE `doctor_availability`;
TRUNCATE TABLE `doctor_experience`;
TRUNCATE TABLE `doctor_education`;
TRUNCATE TABLE `doctor_profiles`;
TRUNCATE TABLE `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- USERS (Patients and Doctors)
-- ============================================
INSERT INTO `users` (`email`, `hashed_password`, `full_name`, `phone_number`, `avatar`, `role`, `is_active`) VALUES
-- Test Account
('a@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Test User', '0901234567', NULL, 'PATIENT', TRUE),

-- Patients
('nguyen.vana@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Nguyễn Văn An', '0912345678', 'https://i.pravatar.cc/150?img=11', 'PATIENT', TRUE),
('tran.thib@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Trần Thị Bích', '0912345679', 'https://i.pravatar.cc/150?img=5', 'PATIENT', TRUE),
('le.hoangc@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Lê Hoàng Châu', '0923456789', 'https://i.pravatar.cc/150?img=12', 'PATIENT', TRUE),
('pham.minhtien@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Phạm Minh Tiến', '0934567890', 'https://i.pravatar.cc/150?img=13', 'PATIENT', TRUE),
('vo.thue@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Võ Thu Ế', '0945678901', 'https://i.pravatar.cc/150?img=9', 'PATIENT', TRUE),

-- Doctors
('dr.nguyenthanhf@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'BS. Nguyễn Thanh Phong', '0912111111', 'https://i.pravatar.cc/150?img=33', 'DOCTOR', TRUE),
('dr.tranthig@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'TS. Trần Thị Giang', '0912222222', 'https://i.pravatar.cc/150?img=44', 'DOCTOR', TRUE),
('dr.levanhung@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'BS. Lê Văn Hùng', '0912333333', 'https://i.pravatar.cc/150?img=14', 'DOCTOR', TRUE),
('dr.phamthii@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'ThS. Phạm Thị Hoa', '0912444444', 'https://i.pravatar.cc/150?img=47', 'DOCTOR', TRUE),
('dr.hoangtank@gmail.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'PGS.TS. Hoàng Tấn Khoa', '0912555555', 'https://i.pravatar.cc/150?img=52', 'DOCTOR', TRUE);

-- ============================================
-- DOCTOR PROFILES (After trigger creates them, we update)
-- ============================================
UPDATE `doctor_profiles` dp
JOIN `users` u ON dp.user_id = u.id
SET 
    dp.specialization = CASE u.email
        WHEN 'dr.nguyenthanhf@gmail.com' THEN 'Tâm lý học lâm sàng'
        WHEN 'dr.tranthig@gmail.com' THEN 'Tâm thần học'
        WHEN 'dr.levanhung@gmail.com' THEN 'Tâm lý trẻ em và vị thành niên'
        WHEN 'dr.phamthii@gmail.com' THEN 'Tư vấn tâm lý gia đình'
        WHEN 'dr.hoangtank@gmail.com' THEN 'Nghiên cứu tâm lý học'
    END,
    dp.bio = CASE u.email
        WHEN 'dr.nguyenthanhf@gmail.com' THEN 'Bác sĩ chuyên khoa I tâm lý lâm sàng với 12 năm kinh nghiệm điều trị các rối loạn lo âu, trầm cảm và stress. Tốt nghiệp Đại học Y Hà Nội và có Thạc sĩ tâm lý học từ Pháp.'
        WHEN 'dr.tranthig@gmail.com' THEN 'Tiến sĩ Y khoa chuyên ngành Tâm thần học. 15 năm kinh nghiệm trong điều trị các bệnh lý tâm thần nghiêm trọng, rối loạn lo âu và trầm cảm. Giảng viên tại Đại học Y Dược TP.HCM.'
        WHEN 'dr.levanhung@gmail.com' THEN 'Bác sĩ chuyên về tâm lý trẻ em và thanh thiếu niên. 8 năm kinh nghiệm hỗ trợ các vấn đề về học tập, hành vi và cảm xúc ở trẻ. Đã tham gia nhiều dự án can thiệp tâm lý tại trường học.'
        WHEN 'dr.phamthii@gmail.com' THEN 'Thạc sĩ tâm lý học chuyên về tư vấn gia đình và hôn nhân. 10 năm kinh nghiệm giúp đỡ các cặp vợ chồng và gia đình giải quyết xung đột, cải thiện mối quan hệ.'
        WHEN 'dr.hoangtank@gmail.com' THEN 'Phó Giáo sư, Tiến sĩ tâm lý học. Chuyên gia hàng đầu về nghiên cứu hành vi và nhận thức. 20 năm kinh nghiệm nghiên cứu và giảng dạy, tác giả nhiều công trình khoa học quốc tế.'
    END,
    dp.consultation_fee = CASE u.email
        WHEN 'dr.nguyenthanhf@gmail.com' THEN 500000
        WHEN 'dr.tranthig@gmail.com' THEN 800000
        WHEN 'dr.levanhung@gmail.com' THEN 450000
        WHEN 'dr.phamthii@gmail.com' THEN 600000
        WHEN 'dr.hoangtank@gmail.com' THEN 1000000
    END,
    dp.years_of_experience = CASE u.email
        WHEN 'dr.nguyenthanhf@gmail.com' THEN 12
        WHEN 'dr.tranthig@gmail.com' THEN 15
        WHEN 'dr.levanhung@gmail.com' THEN 8
        WHEN 'dr.phamthii@gmail.com' THEN 10
        WHEN 'dr.hoangtank@gmail.com' THEN 20
    END,
    dp.rating = CASE u.email
        WHEN 'dr.nguyenthanhf@gmail.com' THEN 4.8
        WHEN 'dr.tranthig@gmail.com' THEN 4.9
        WHEN 'dr.levanhung@gmail.com' THEN 4.7
        WHEN 'dr.phamthii@gmail.com' THEN 4.6
        WHEN 'dr.hoangtank@gmail.com' THEN 4.9
    END,
    dp.review_count = CASE u.email
        WHEN 'dr.nguyenthanhf@gmail.com' THEN 124
        WHEN 'dr.tranthig@gmail.com' THEN 89
        WHEN 'dr.levanhung@gmail.com' THEN 156
        WHEN 'dr.phamthii@gmail.com' THEN 78
        WHEN 'dr.hoangtank@gmail.com' THEN 45
    END
WHERE u.role = 'DOCTOR';

-- ============================================
-- DOCTOR EDUCATION
-- ============================================
INSERT INTO `doctor_education` (`doctor_id`, `degree`, `university`, `year`)
SELECT dp.id, degree, university, year FROM doctor_profiles dp
JOIN users u ON dp.user_id = u.id
JOIN (
    SELECT 'dr.nguyenthanhf@gmail.com' as email, 'Bác sĩ Y khoa' as degree, 'Đại học Y Hà Nội' as university, 2008 as year
    UNION SELECT 'dr.nguyenthanhf@gmail.com', 'Thạc sĩ Tâm lý học', 'Đại học Paris Descartes, Pháp', 2012
    UNION SELECT 'dr.tranthig@gmail.com', 'Bác sĩ Y khoa', 'Đại học Y Dược TP.HCM', 2005
    UNION SELECT 'dr.tranthig@gmail.com', 'Tiến sĩ Tâm thần học', 'Đại học Y Hà Nội', 2010
    UNION SELECT 'dr.levanhung@gmail.com', 'Bác sĩ Y khoa', 'Đại học Y Dược TP.HCM', 2012
    UNION SELECT 'dr.levanhung@gmail.com', 'Chứng chỉ Tâm lý trẻ em', 'Viện Tâm lý học Việt Nam', 2015
    UNION SELECT 'dr.phamthii@gmail.com', 'Cử nhân Tâm lý học', 'Đại học KHXH&NV Hà Nội', 2010
    UNION SELECT 'dr.phamthii@gmail.com', 'Thạc sĩ Tâm lý tư vấn', 'Đại học Quốc gia Hà Nội', 2013
    UNION SELECT 'dr.hoangtank@gmail.com', 'Cử nhân Tâm lý học', 'Đại học Quốc gia Hà Nội', 2000
    UNION SELECT 'dr.hoangtank@gmail.com', 'Thạc sĩ Tâm lý học', 'Đại học Stanford, Mỹ', 2003
    UNION SELECT 'dr.hoangtank@gmail.com', 'Tiến sĩ Tâm lý học', 'Harvard University, Mỹ', 2008
) edu ON u.email = edu.email;

-- ============================================
-- DOCTOR EXPERIENCE
-- ============================================
INSERT INTO `doctor_experience` (`doctor_id`, `position`, `hospital`, `start_year`, `end_year`, `is_current`)
SELECT dp.id, position, hospital, start_year, end_year, is_current FROM doctor_profiles dp
JOIN users u ON dp.user_id = u.id
JOIN (
    SELECT 'dr.nguyenthanhf@gmail.com' as email, 'Bác sĩ nội trú' as position, 'Bệnh viện Tâm thần Trung ương I' as hospital, 2008 as start_year, 2012 as end_year, FALSE as is_current
    UNION SELECT 'dr.nguyenthanhf@gmail.com', 'Bác sĩ điều trị', 'Bệnh viện Đa khoa Quốc tế Vinmec', 2012, 2018, FALSE
    UNION SELECT 'dr.nguyenthanhf@gmail.com', 'Trưởng khoa Tâm lý', 'Bệnh viện Đa khoa Quốc tế Vinmec', 2018, NULL, TRUE
    UNION SELECT 'dr.tranthig@gmail.com', 'Bác sĩ nội trú', 'Bệnh viện Tâm thần TP.HCM', 2005, 2010, FALSE
    UNION SELECT 'dr.tranthig@gmail.com', 'Phó Giám đốc chuyên môn', 'Trung tâm Tâm thần học TP.HCM', 2010, NULL, TRUE
    UNION SELECT 'dr.levanhung@gmail.com', 'Tâm lý viên', 'Trường THPT Lê Hồng Phong', 2012, 2016, FALSE
    UNION SELECT 'dr.levanhung@gmail.com', 'Bác sĩ tâm lý', 'Phòng khám Tâm lý Kids Care', 2016, NULL, TRUE
    UNION SELECT 'dr.phamthii@gmail.com', 'Tư vấn viên', 'Trung tâm Tư vấn gia đình Hà Nội', 2013, 2018, FALSE
    UNION SELECT 'dr.phamthii@gmail.com', 'Chuyên gia tư vấn cấp cao', 'Family Counseling Center', 2018, NULL, TRUE
    UNION SELECT 'dr.hoangtank@gmail.com', 'Giảng viên', 'Đại học Quốc gia Hà Nội', 2008, 2015, FALSE
    UNION SELECT 'dr.hoangtank@gmail.com', 'Phó Giáo sư', 'Đại học Quốc gia Hà Nội', 2015, NULL, TRUE
) exp ON u.email = exp.email;

-- ============================================
-- CHATS
-- ============================================
INSERT INTO `chats` (`created_at`, `updated_at`) VALUES
(NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 1 HOUR),
(NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 2 HOUR),
(NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 30 MINUTE),
(NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 10 MINUTE);

-- ============================================
-- CHAT PARTICIPANTS
-- ============================================
INSERT INTO `chat_participants` (`chat_id`, `user_id`)
SELECT chat_id, user_id FROM (
    SELECT 1 as chat_id, (SELECT id FROM users WHERE email = 'a@gmail.com') as user_id
    UNION SELECT 1, (SELECT id FROM users WHERE email = 'dr.nguyenthanhf@gmail.com')
    UNION SELECT 2, (SELECT id FROM users WHERE email = 'nguyen.vana@gmail.com') as user_id
    UNION SELECT 2, (SELECT id FROM users WHERE email = 'dr.tranthig@gmail.com')
    UNION SELECT 3, (SELECT id FROM users WHERE email = 'tran.thib@gmail.com')
    UNION SELECT 3, (SELECT id FROM users WHERE email = 'dr.levanhung@gmail.com')
    UNION SELECT 4, (SELECT id FROM users WHERE email = 'pham.minhtien@gmail.com')
    UNION SELECT 4, (SELECT id FROM users WHERE email = 'dr.phamthii@gmail.com')
) t;

-- ============================================
-- MESSAGES
-- ============================================
INSERT INTO `messages` (`chat_id`, `sender_id`, `content`, `read`, `created_at`)
SELECT chat_id, sender_id, content, `read`, created_at FROM (
    -- Chat 1: Test User <-> Dr. Phong
    SELECT 1 as chat_id, (SELECT id FROM users WHERE email = 'a@gmail.com') as sender_id, 
           'Chào bác sĩ, em muốn tư vấn về vấn đề stress trong công việc ạ.' as content, 
           TRUE as `read`, NOW() - INTERVAL 7 DAY as created_at
    UNION SELECT 1, (SELECT id FROM users WHERE email = 'dr.nguyenthanhf@gmail.com'), 
           'Chào bạn! Bác sĩ rất sẵn lòng hỗ trợ. Bạn có thể chia sẻ cụ thể hơn về tình trạng hiện tại không?', 
           TRUE, NOW() - INTERVAL 7 DAY + INTERVAL 10 MINUTE
    UNION SELECT 1, (SELECT id FROM users WHERE email = 'a@gmail.com'), 
           'Dạ em thường xuyên cảm thấy lo lắng và mất tập trung khi làm việc. Đêm cũng hay mất ngủ ạ.', 
           TRUE, NOW() - INTERVAL 7 DAY + INTERVAL 25 MINUTE
    UNION SELECT 1, (SELECT id FROM users WHERE email = 'dr.nguyenthanhf@gmail.com'),
           'Cảm ơn bạn đã chia sẻ. Những triệu chứng này khá phổ biến với stress công việc. Chúng ta nên đặt lịch gặp trực tiếp để tìm hiểu kỹ hơn nhé.', 
           FALSE, NOW() - INTERVAL 1 HOUR
           
    -- Chat 2: Nguyễn Văn An <-> Dr. Giang
    UNION SELECT 2, (SELECT id FROM users WHERE email = 'nguyen.vana@gmail.com'), 
           'Bác sĩ ơi, gần đây tôi hay có cảm giác lo lắng vô cớ, tim đập nhanh.', 
           TRUE, NOW() - INTERVAL 5 DAY
    UNION SELECT 2, (SELECT id FROM users WHERE email = 'dr.tranthig@gmail.com'),
           'Chào anh. Triệu chứng anh mô tả có thể liên quan đến rối loạn lo âu. Anh có thể kể thêm về thời điểm xuất hiện triệu chứng không?', 
           TRUE, NOW() - INTERVAL 5 DAY + INTERVAL 1 HOUR
    UNION SELECT 2, (SELECT id FROM users WHERE email = 'nguyen.vana@gmail.com'),
           'Dạ thường xảy ra vào buổi tối trước khi đi ngủ, hoặc khi phải thuyết trình ạ.', 
           FALSE, NOW() - INTERVAL 2 HOUR
           
    -- Chat 3: Trần Thị Bích <-> Dr. Hùng  
    UNION SELECT 3, (SELECT id FROM users WHERE email = 'tran.thib@gmail.com'),
           'Bác sĩ cho em hỏi, con em học lớp 8 gần đây hay cáu gắt và không chịu học hành.', 
           TRUE, NOW() - INTERVAL 3 DAY
    UNION SELECT 3, (SELECT id FROM users WHERE email = 'dr.levanhung@gmail.com'),
           'Chào chị. Đây là dấu hiệu cần lưu ý ở tuổi vị thành niên. Chị có để ý thêm hành vi nào khác bất thường không?', 
           TRUE, NOW() - INTERVAL 3 DAY + INTERVAL 30 MINUTE
    UNION SELECT 3, (SELECT id FROM users WHERE email = 'tran.thib@gmail.com'),
           'Dạ có ạ, con cũng hay nhốt mình trong phòng và ít nói chuyện với gia đình hơn.',
           TRUE, NOW() - INTERVAL 3 DAY + INTERVAL 1 HOUR
    UNION SELECT 3, (SELECT id FROM users WHERE email = 'dr.levanhung@gmail.com'),
           'Cảm ơn chị đã chia sẻ. Tôi nghĩ nên có buổi gặp cả gia đình để hiểu rõ hơn tình hình. Chị có thể đặt lịch được không?',
           FALSE, NOW() - INTERVAL 30 MINUTE
           
    -- Chat 4: Phạm Minh Tiến <-> Dr. Hoa
    UNION SELECT 4, (SELECT id FROM users WHERE email = 'pham.minhtien@gmail.com'),
           'Chào bác sĩ, tôi và vợ đang có một số vấn đề trong giao tiếp, muốn được tư vấn ạ.', 
           TRUE, NOW() - INTERVAL 1 DAY
    UNION SELECT 4, (SELECT id FROM users WHERE email = 'dr.phamthii@gmail.com'),
           'Chào anh. Rất vui được hỗ trợ anh. Anh có thể mô tả sơ qua về vấn đề chính không ạ?', 
           TRUE, NOW() - INTERVAL 23 HOUR
    UNION SELECT 4, (SELECT id FROM users WHERE email = 'pham.minhtien@gmail.com'),
           'Dạ chúng tôi hay có những cuộc tranh cãi về cách nuôi dạy con, và không ai chịu nghe ai cả.',
           FALSE, NOW() - INTERVAL 10 MINUTE
) msg;

-- ============================================
-- MOOD ENTRIES
-- ============================================
INSERT INTO `mood_entries` (`user_id`, `mood`, `notes`, `created_at`)
SELECT user_id, mood, notes, created_at FROM (
    SELECT (SELECT id FROM users WHERE email = 'a@gmail.com') as user_id, 'HAPPY' as mood, 'Hôm nay làm việc hiệu quả!' as notes, NOW() - INTERVAL 1 DAY as created_at
    UNION SELECT (SELECT id FROM users WHERE email = 'a@gmail.com'), 'CALM', 'Đi dạo công viên, thư giãn', NOW() - INTERVAL 2 DAY
    UNION SELECT (SELECT id FROM users WHERE email = 'a@gmail.com'), 'STRESSED', 'Deadline dự án gấp', NOW() - INTERVAL 3 DAY
    UNION SELECT (SELECT id FROM users WHERE email = 'nguyen.vana@gmail.com'), 'ANXIOUS', 'Lo lắng về công việc', NOW() - INTERVAL 1 DAY
    UNION SELECT (SELECT id FROM users WHERE email = 'tran.thib@gmail.com'), 'SAD', 'Con không chịu học', NOW() - INTERVAL 2 DAY
    UNION SELECT (SELECT id FROM users WHERE email = 'pham.minhtien@gmail.com'), 'TIRED', 'Làm việc mệt mỏi', NOW() - INTERVAL 1 DAY
) mood;

-- ============================================
-- JOURNAL ENTRIES
-- ============================================
INSERT INTO `journal_entries` (`user_id`, `title`, `content`, `created_at`)
SELECT user_id, title, content, created_at FROM (
    SELECT (SELECT id FROM users WHERE email = 'a@gmail.com') as user_id, 
           'Một ngày bận rộn' as title, 
           'Hôm nay tôi hoàn thành được nhiều công việc. Tuy nhiên vẫn còn cảm giác áp lực về deadline sắp tới. Cần phải sắp xếp thời gian hợp lý hơn.' as content,
           NOW() - INTERVAL 1 DAY as created_at
    UNION SELECT (SELECT id FROM users WHERE email = 'a@gmail.com'), 
           'Suy nghĩ về tương lai', 
           'Tôi băn khoăn về hướng đi career của mình. Liệu có nên chuyển công việc? Cần thời gian để suy nghĩ kỹ hơn.',
           NOW() - INTERVAL 3 DAY
    UNION SELECT (SELECT id FROM users WHERE email = 'nguyen.vana@gmail.com'),
           'Cảm xúc hôm nay',
           'Hôm nay tôi cảm thấy lo lắng vô cớ. Không rõ nguyên nhân nhưng tim cứ đập nhanh. May mắn đã tìm được bác sĩ để tư vấn.',
           NOW() - INTERVAL 2 DAY
) journal;

-- ============================================
-- APPOINTMENTS
-- ============================================
INSERT INTO `appointments` (`doctor_id`, `patient_id`, `appointment_date`, `time_slot`, `status`, `reason`, `notes`)
SELECT doctor_id, patient_id, appointment_date, time_slot, status, reason, notes FROM (
    SELECT (SELECT id FROM users WHERE email = 'dr.nguyenthanhf@gmail.com') as doctor_id,
           (SELECT id FROM users WHERE email = 'a@gmail.com') as patient_id,
           DATE_ADD(CURDATE(), INTERVAL 3 DAY) as appointment_date,
           '09:00' as time_slot,
           'CONFIRMED' as status,
           'Tư vấn về stress công việc' as reason,
           'Lần đầu đến tư vấn' as notes
    UNION SELECT (SELECT id FROM users WHERE email = 'dr.tranthig@gmail.com'),
           (SELECT id FROM users WHERE email = 'nguyen.vana@gmail.com'),
           DATE_ADD(CURDATE(), INTERVAL 5 DAY),
           '14:00',
           'PENDING',
           'Rối loạn lo âu',
           'Cần đánh giá tổng quát'
    UNION SELECT (SELECT id FROM users WHERE email = 'dr.levanhung@gmail.com'),
           (SELECT id FROM users WHERE email = 'tran.thib@gmail.com'),
           DATE_ADD(CURDATE(), INTERVAL 7 DAY),
           '10:30',
           'CONFIRMED',
           'Tư vấn về con cái',
           'Gặp cả gia đình'
    UNION SELECT (SELECT id FROM users WHERE email = 'dr.nguyenthanhf@gmail.com'),
           (SELECT id FROM users WHERE email = 'nguyen.vana@gmail.com'),
           CURDATE() - INTERVAL 10 DAY,
           '15:00',
           'COMPLETED',
           'Khám định kỳ',
           'Tiến triển tốt'
) appt;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
SELECT 'Users created:' as Info, COUNT(*) as Count FROM users
UNION SELECT 'Doctors:', COUNT(*) FROM users WHERE role = 'DOCTOR'
UNION SELECT 'Patients:', COUNT(*) FROM users WHERE role = 'PATIENT'
UNION SELECT 'Doctor profiles:', COUNT(*) FROM doctor_profiles
UNION SELECT 'Chats:', COUNT(*) FROM chats
UNION SELECT 'Messages:', COUNT(*) FROM messages
UNION SELECT 'Mood entries:', COUNT(*) FROM mood_entries
UNION SELECT 'Journal entries:', COUNT(*) FROM journal_entries
UNION SELECT 'Appointments:', COUNT(*) FROM appointments;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;
