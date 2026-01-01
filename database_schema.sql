-- Tạo database
CREATE DATABASE IF NOT EXISTS `bemindcare` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `bemindcare`;

-- Tạo bảng users
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `hashed_password` VARCHAR(255) NOT NULL,
    `full_name` VARCHAR(100) NOT NULL,
    `phone_number` VARCHAR(20),
    `avatar` VARCHAR(255),
    `role` ENUM('PATIENT', 'DOCTOR') NOT NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_email` (`email`),
    INDEX `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng doctor_profiles
CREATE TABLE IF NOT EXISTS `doctor_profiles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `specialization` VARCHAR(100) NOT NULL,
    `bio` TEXT,
    `consultation_fee` DECIMAL(10, 2) DEFAULT 0.00,
    `years_of_experience` INT DEFAULT 0,
    `rating` FLOAT DEFAULT 0.0,
    `review_count` INT DEFAULT 0,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_specialization` (`specialization`),
    INDEX `idx_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng doctor_education
CREATE TABLE IF NOT EXISTS `doctor_education` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `doctor_id` INT NOT NULL,
    `degree` VARCHAR(100) NOT NULL,
    `university` VARCHAR(255) NOT NULL,
    `year` INT NOT NULL,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctor_profiles`(`id`) ON DELETE CASCADE,
    INDEX `idx_doctor_edu` (`doctor_id`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng doctor_experience
CREATE TABLE IF NOT EXISTS `doctor_experience` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `doctor_id` INT NOT NULL,
    `position` VARCHAR(100) NOT NULL,
    `hospital` VARCHAR(255) NOT NULL,
    `start_year` INT NOT NULL,
    `end_year` INT,
    `is_current` BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctor_profiles`(`id`) ON DELETE CASCADE,
    INDEX `idx_doctor_exp` (`doctor_id`, `start_year` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng appointments
CREATE TABLE IF NOT EXISTS `appointments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `doctor_id` INT NOT NULL,
    `patient_id` INT NOT NULL,
    `appointment_date` DATE NOT NULL,
    `time_slot` VARCHAR(50) NOT NULL,
    `status` ENUM('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    `reason` TEXT NOT NULL,
    `notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`doctor_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`patient_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_appointment_date` (`appointment_date`),
    INDEX `idx_status` (`status`),
    INDEX `idx_doctor_appointment` (`doctor_id`, `appointment_date`),
    INDEX `idx_patient_appointment` (`patient_id`, `appointment_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng doctor_availability
CREATE TABLE IF NOT EXISTS `doctor_availability` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `doctor_id` INT NOT NULL,
    `date` DATE NOT NULL,
    `time_slot` VARCHAR(50) NOT NULL,
    `is_available` BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctor_profiles`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_doctor_time_slot` (`doctor_id`, `date`, `time_slot`),
    INDEX `idx_availability` (`doctor_id`, `date`, `is_available`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Create chats table
CREATE TABLE IF NOT EXISTS `chats` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create chat_participants table
CREATE TABLE IF NOT EXISTS `chat_participants` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `chat_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`chat_id`) REFERENCES `chats`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_chat_user` (`chat_id`, `user_id`),
    INDEX `idx_chat_user` (`chat_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create messages table
CREATE TABLE IF NOT EXISTS `messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `chat_id` INT NOT NULL,
    `sender_id` INT NOT NULL,
    `content` TEXT NOT NULL,
    `read` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`chat_id`) REFERENCES `chats`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`sender_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_chat_created` (`chat_id`, `created_at`),
    INDEX `idx_sender` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create mood_entries table
CREATE TABLE IF NOT EXISTS `mood_entries` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `mood` ENUM('HAPPY', 'SAD', 'ANXIOUS', 'STRESSED', 'CALM', 'ANGRY', 'TIRED', 'EXCITED') NOT NULL,
    `notes` TEXT,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_user_created` (`user_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- Thêm trigger để tự động tạo bản ghi trong doctor_profiles khi có user mới là bác sĩ
DELIMITER //
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'DOCTOR' THEN
        INSERT INTO doctor_profiles (user_id, specialization)
        VALUES (NEW.id, 'Chưa cập nhật');
    END IF;
END//
DELIMITER ;

-- Tạo view để lấy thông tin chi tiết bác sĩ
CREATE OR REPLACE VIEW vw_doctor_details AS
SELECT 
    u.id,
    u.email,
    u.full_name,
    u.phone_number,
    u.avatar,
    u.created_at,
    dp.specialization,
    dp.bio,
    dp.consultation_fee,
    dp.years_of_experience,
    dp.rating,
    dp.review_count,
    (SELECT COUNT(*) FROM appointments a WHERE a.doctor_id = u.id) as total_appointments
FROM 
    users u
JOIN 
    doctor_profiles dp ON u.id = dp.user_id
WHERE 
    u.role = 'DOCTOR';

-- Tạo stored procedure để lấy lịch hẹn theo bác sĩ và ngày
DELIMITER //
CREATE PROCEDURE GetDoctorAppointments(IN p_doctor_id INT, IN p_date DATE)
BEGIN
    SELECT 
        a.*,
        u.full_name as patient_name,
        u.phone_number as patient_phone
    FROM 
        appointments a
    JOIN 
        users u ON a.patient_id = u.id
    WHERE 
        a.doctor_id = p_doctor_id 
        AND a.appointment_date = p_date
    ORDER BY 
        a.time_slot;
END//
DELIMITER ;
