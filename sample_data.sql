-- Sample data for BEMindCare database
-- Password for all users: password123 (hashed with bcrypt)

-- Insert sample users (patients and doctors)
INSERT INTO `users` (`email`, `hashed_password`, `full_name`, `phone_number`, `avatar`, `role`, `is_active`) VALUES
-- Patients
('patient1@example.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Nguyễn Văn A', '0912345678', 'https://example.com/avatars/1.jpg', 'PATIENT', TRUE),
('patient2@example.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'Trần Thị B', '0912345679', 'https://example.com/avatars/2.jpg', 'PATIENT', TRUE),
-- Doctors
('doctor1@example.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'BS. Lê Văn C', '0912345680', 'https://example.com/avatars/3.jpg', 'DOCTOR', TRUE),
('doctor2@example.com', '$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s', 'TS. Phạm Thị D', '0912345681', 'https://example.com/avatars/4.jpg', 'DOCTOR', TRUE);

-- Update doctor profiles (trigger will create them, we just need to update)
UPDATE `doctor_profiles` SET 
    `specialization` = 'Tâm lý học lâm sàng',
    `bio` = 'Chuyên gia tâm lý với 10 năm kinh nghiệm',
    `consultation_fee` = 500000,
    `years_of_experience` = 10,
    `rating` = 4.8,
    `review_count` = 125
WHERE `user_id` = 3;

UPDATE `doctor_profiles` SET 
    `specialization` = 'Tâm thần học',
    `bio` = 'Tiến sĩ tâm thần học, chuyên điều trị trầm cảm và lo âu',
    `consultation_fee` = 700000,
    `years_of_experience` = 15,
    `rating` = 4.9,
    `review_count` = 200
WHERE `user_id` = 4;

-- Doctor education
INSERT INTO `doctor_education` (`doctor_id`, `degree`, `university`, `year`) VALUES
(1, 'Bác sĩ Y khoa', 'Đại học Y Hà Nội', 2010),
(1, 'Thạc sĩ Tâm lý học lâm sàng', 'Đại học Khoa học Xã hội và Nhân văn', 2013),
(2, 'Bác sĩ Y khoa', 'Đại học Y Dược TP.HCM', 2005),
(2, 'Tiến sĩ Tâm thần học', 'Đại học Y Hà Nội', 2011);

-- Doctor experience
INSERT INTO `doctor_experience` (`doctor_id`, `position`, `hospital`, `start_year`, `end_year`, `is_current`) VALUES
(1, 'Bác sĩ tâm lý', 'Bệnh viện Tâm thần Trung ương 1', 2010, 2015, FALSE),
(1, 'Trưởng khoa Tâm lý', 'Bệnh viện Đa khoa Quốc tế Vinmec', 2015, NULL, TRUE),
(2, 'Bác sĩ nội trú', 'Bệnh viện Tâm thần Trung ương 2', 2005, 2010, FALSE),
(2, 'Phó Giám đốc chuyên môn', 'Bệnh viện Đa khoa Quốc tế Vinmec', 2011, NULL, TRUE);

-- Appointments
INSERT INTO `appointments` (`doctor_id`, `patient_id`, `appointment_date`, `time_slot`, `status`, `reason`, `notes`) VALUES
(3, 1, '2025-01-15', '09:00', 'CONFIRMED', 'Tư vấn tâm lý', 'Bệnh nhân có tiền sử trầm cảm'),
(3, 2, '2025-01-15', '10:30', 'PENDING', 'Kiểm tra sức khỏe tâm thần', 'Cần kiểm tra thêm'),
(4, 1, '2025-01-16', '14:00', 'COMPLETED', 'Theo dõi điều trị', 'Đáp ứng tốt với thuốc');

-- Doctor availability
INSERT INTO `doctor_availability` (`doctor_id`, `date`, `time_slot`, `is_available`) VALUES
(1, '2025-01-15', '09:00', FALSE),  -- Đã đặt lịch
(1, '2025-01-15', '10:30', FALSE),  -- Đã đặt lịch
(1, '2025-01-15', '14:00', TRUE),   -- Còn trống
(2, '2025-01-16', '14:00', FALSE),  -- Đã đặt lịch
(2, '2025-01-16', '15:30', TRUE);   -- Còn trống

-- Mood entries
INSERT INTO `mood_entries` (`user_id`, `mood`, `notes`, `created_at`) VALUES
(1, 'HAPPY', 'Cảm thấy rất vui hôm nay', '2025-01-01 08:00:00'),
(1, 'SAD', 'Có chút buồn', '2025-01-02 20:00:00'),
(2, 'ANXIOUS', 'Hơi lo lắng về công việc', '2025-01-01 10:30:00');

-- Chats and messages
INSERT INTO `chats` (`created_at`, `updated_at`) VALUES
('2025-01-01 10:00:00', '2025-01-01 10:15:00'),
('2025-01-02 14:30:00', '2025-01-02 15:00:00');

-- Chat participants (doctor1 and patient1 in chat 1, doctor2 and patient2 in chat 2)
INSERT INTO `chat_participants` (`chat_id`, `user_id`, `created_at`) VALUES
(1, 1, '2025-01-01 10:00:00'),
(1, 3, '2025-01-01 10:00:00'),
(2, 2, '2025-01-02 14:30:00'),
(2, 4, '2025-01-02 14:30:00');

-- Messages
INSERT INTO `messages` (`chat_id`, `sender_id`, `content`, `read`, `created_at`) VALUES
(1, 1, 'Xin chào bác sĩ, tôi muốn đặt lịch hẹn', TRUE, '2025-01-01 10:00:00'),
(1, 3, 'Chào bạn, tôi có thể giúp gì cho bạn?', TRUE, '2025-01-01 10:05:00'),
(2, 4, 'Chào bạn, bạn cần tư vấn gì không?', TRUE, '2025-01-02 14:30:00'),
(2, 2, 'Dạ em muốn hỏi về tình trạng của mình ạ', TRUE, '2025-01-02 14:35:00');
