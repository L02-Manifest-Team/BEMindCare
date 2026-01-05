CREATE DATABASE  IF NOT EXISTS `bemindcare` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bemindcare`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: bemindcare
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `appointment_date` date NOT NULL,
  `time_slot` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PENDING','CONFIRMED','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_appointment_date` (`appointment_date`),
  KEY `idx_status` (`status`),
  KEY `idx_doctor_appointment` (`doctor_id`,`appointment_date`),
  KEY `idx_patient_appointment` (`patient_id`,`appointment_date`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,7,1,'2026-01-08','09:00','CONFIRMED','Tư vấn về stress công việc','Lần đầu đến tư vấn','2026-01-04 17:33:37','2026-01-04 17:33:37'),(2,8,2,'2026-01-10','14:00','PENDING','Rối loạn lo âu','Cần đánh giá tổng quát','2026-01-04 17:33:37','2026-01-04 17:33:37'),(3,9,3,'2026-01-12','10:30','CONFIRMED','Tư vấn về con cái','Gặp cả gia đình','2026-01-04 17:33:37','2026-01-04 17:33:37'),(4,7,2,'2025-12-26','15:00','COMPLETED','Khám định kỳ','Tiến triển tốt','2026-01-04 17:33:37','2026-01-04 17:33:37'),(9,8,12,'2026-01-06','17:00','PENDING','hhh','In-person appointment','2026-01-05 05:09:23',NULL),(11,10,12,'2026-01-05','15:00','PENDING','hhh','In-person appointment - Dĩ An','2026-01-05 05:30:18',NULL),(12,8,12,'2026-01-05','17:00','CANCELLED','ghnh','In-person appointment - 268 Lý Thường Kiệt','2026-01-05 05:40:21','2026-01-05 06:05:49'),(13,8,12,'2026-01-05','18:00','CANCELLED','aa','In-person appointment - 268 Lý Thường Kiệt','2026-01-05 06:04:22','2026-01-05 06:06:20'),(14,10,12,'2026-01-05','18:00','CANCELLED','hhh','In-person appointment - 268 Lý Thường Kiệt','2026-01-05 06:23:22','2026-01-05 16:31:15'),(15,9,12,'2026-01-06','16:00','PENDING','jjj','Video call appointment','2026-01-05 06:27:14',NULL),(16,13,12,'2026-01-06','10:00','CONFIRMED','nay bun qua','In-person appointment - 268 Lý Thường Kiệt','2026-01-05 07:16:22','2026-01-05 07:21:15'),(17,13,12,'2026-01-06','09:00','CONFIRMED','Hhhh','In-person appointment - 268 Lý Thường Kiệt','2026-01-05 16:31:59','2026-01-05 16:33:20');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_participants`
--

DROP TABLE IF EXISTS `chat_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_participants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_chat_user` (`chat_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_chat_user` (`chat_id`,`user_id`),
  CONSTRAINT `chat_participants_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_participants_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_participants`
--

LOCK TABLES `chat_participants` WRITE;
/*!40000 ALTER TABLE `chat_participants` DISABLE KEYS */;
INSERT INTO `chat_participants` VALUES (1,1,1,'2026-01-05 00:33:37'),(2,1,7,'2026-01-05 00:33:37'),(3,2,2,'2026-01-05 00:33:37'),(4,2,8,'2026-01-05 00:33:37'),(5,3,3,'2026-01-05 00:33:37'),(6,3,9,'2026-01-05 00:33:37'),(7,4,5,'2026-01-05 00:33:37'),(8,4,10,'2026-01-05 00:33:37'),(16,5,12,'2026-01-05 00:47:38'),(17,5,8,'2026-01-05 00:47:38'),(18,6,12,'2026-01-05 00:58:23'),(19,6,10,'2026-01-05 00:58:23'),(20,7,12,'2026-01-05 01:13:41'),(21,7,11,'2026-01-05 01:13:41'),(22,8,12,'2026-01-05 01:41:23'),(23,8,7,'2026-01-05 01:41:23'),(24,9,12,'2026-01-05 01:41:30'),(25,9,9,'2026-01-05 01:41:30'),(26,10,12,'2026-01-05 14:32:10'),(27,10,13,'2026-01-05 14:32:10'),(28,11,14,'2026-01-06 00:44:33'),(29,11,13,'2026-01-06 00:44:33');
/*!40000 ALTER TABLE `chat_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats`
--

DROP TABLE IF EXISTS `chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats`
--

LOCK TABLES `chats` WRITE;
/*!40000 ALTER TABLE `chats` DISABLE KEYS */;
INSERT INTO `chats` VALUES (1,'2025-12-29 00:33:37','2026-01-04 23:33:37'),(2,'2025-12-31 00:33:37','2026-01-04 22:33:37'),(3,'2026-01-02 00:33:37','2026-01-05 00:03:37'),(4,'2026-01-04 00:33:37','2026-01-05 00:23:37'),(5,'2026-01-04 17:47:38','2026-01-05 00:47:38'),(6,'2026-01-04 17:58:23','2026-01-05 00:58:23'),(7,'2026-01-04 18:13:41','2026-01-05 01:13:41'),(8,'2026-01-04 18:41:24','2026-01-05 01:41:23'),(9,'2026-01-04 18:41:31','2026-01-05 01:41:30'),(10,'2026-01-05 07:32:10','2026-01-05 14:32:10'),(11,'2026-01-05 17:44:33','2026-01-06 00:44:33');
/*!40000 ALTER TABLE `chats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_availability`
--

DROP TABLE IF EXISTS `doctor_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_availability` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `date` date NOT NULL,
  `time_slot` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_doctor_time_slot` (`doctor_id`,`date`,`time_slot`),
  KEY `idx_availability` (`doctor_id`,`date`,`is_available`),
  CONSTRAINT `doctor_availability_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctor_profiles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_availability`
--

LOCK TABLES `doctor_availability` WRITE;
/*!40000 ALTER TABLE `doctor_availability` DISABLE KEYS */;
INSERT INTO `doctor_availability` VALUES (1,2,'2026-01-06','09:00',0),(2,2,'2026-01-06','17:00',0),(3,5,'2026-01-05','10:00',0),(4,4,'2026-01-05','15:00',0),(5,2,'2026-01-05','17:00',0),(6,2,'2026-01-05','18:00',0),(7,4,'2026-01-05','18:00',0),(8,3,'2026-01-06','16:00',0),(9,6,'2026-01-06','10:00',0),(10,6,'2026-01-06','09:00',0);
/*!40000 ALTER TABLE `doctor_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_education`
--

DROP TABLE IF EXISTS `doctor_education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_education` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `degree` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `university` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_doctor_edu` (`doctor_id`,`year`),
  CONSTRAINT `doctor_education_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctor_profiles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_education`
--

LOCK TABLES `doctor_education` WRITE;
/*!40000 ALTER TABLE `doctor_education` DISABLE KEYS */;
INSERT INTO `doctor_education` VALUES (1,1,'Bác sĩ Y khoa','Đại học Y Hà Nội',2008),(2,1,'Thạc sĩ Tâm lý học','Đại học Paris Descartes, Pháp',2012),(3,2,'Bác sĩ Y khoa','Đại học Y Dược TP.HCM',2005),(4,2,'Tiến sĩ Tâm thần học','Đại học Y Hà Nội',2010),(5,3,'Bác sĩ Y khoa','Đại học Y Dược TP.HCM',2012),(6,3,'Chứng chỉ Tâm lý trẻ em','Viện Tâm lý học Việt Nam',2015),(7,4,'Cử nhân Tâm lý học','Đại học KHXH&NV Hà Nội',2010),(8,4,'Thạc sĩ Tâm lý tư vấn','Đại học Quốc gia Hà Nội',2013),(9,5,'Cử nhân Tâm lý học','Đại học Quốc gia Hà Nội',2000),(10,5,'Thạc sĩ Tâm lý học','Đại học Stanford, Mỹ',2003),(11,5,'Tiến sĩ Tâm lý học','Harvard University, Mỹ',2008);
/*!40000 ALTER TABLE `doctor_education` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_experience`
--

DROP TABLE IF EXISTS `doctor_experience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_experience` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `position` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hospital` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_year` int NOT NULL,
  `end_year` int DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_doctor_exp` (`doctor_id`,`start_year` DESC),
  CONSTRAINT `doctor_experience_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctor_profiles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_experience`
--

LOCK TABLES `doctor_experience` WRITE;
/*!40000 ALTER TABLE `doctor_experience` DISABLE KEYS */;
INSERT INTO `doctor_experience` VALUES (1,1,'Bác sĩ nội trú','Bệnh viện Tâm thần Trung ương I',2008,2012,0),(2,1,'Bác sĩ điều trị','Bệnh viện Đa khoa Quốc tế Vinmec',2012,2018,0),(3,1,'Trưởng khoa Tâm lý','Bệnh viện Đa khoa Quốc tế Vinmec',2018,NULL,1),(4,2,'Bác sĩ nội trú','Bệnh viện Tâm thần TP.HCM',2005,2010,0),(5,2,'Phó Giám đốc chuyên môn','Trung tâm Tâm thần học TP.HCM',2010,NULL,1),(6,3,'Tâm lý viên','Trường THPT Lê Hồng Phong',2012,2016,0),(7,3,'Bác sĩ tâm lý','Phòng khám Tâm lý Kids Care',2016,NULL,1),(8,4,'Tư vấn viên','Trung tâm Tư vấn gia đình Hà Nội',2013,2018,0),(9,4,'Chuyên gia tư vấn cấp cao','Family Counseling Center',2018,NULL,1),(10,5,'Giảng viên','Đại học Quốc gia Hà Nội',2008,2015,0),(11,5,'Phó Giáo sư','Đại học Quốc gia Hà Nội',2015,NULL,1);
/*!40000 ALTER TABLE `doctor_experience` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_profiles`
--

DROP TABLE IF EXISTS `doctor_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `specialization` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `consultation_fee` decimal(10,2) DEFAULT '0.00',
  `years_of_experience` int DEFAULT '0',
  `rating` float DEFAULT '0',
  `review_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `idx_specialization` (`specialization`),
  KEY `idx_rating` (`rating`),
  CONSTRAINT `doctor_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_profiles`
--

LOCK TABLES `doctor_profiles` WRITE;
/*!40000 ALTER TABLE `doctor_profiles` DISABLE KEYS */;
INSERT INTO `doctor_profiles` VALUES (1,7,'Tâm lý học lâm sàng','Bác sĩ chuyên khoa I tâm lý lâm sàng với 12 năm kinh nghiệm điều trị các rối loạn lo âu, trầm cảm và stress. Tốt nghiệp Đại học Y Hà Nội và có Thạc sĩ tâm lý học từ Pháp.',500000.00,12,4.8,124),(2,8,'Tâm thần học','Tiến sĩ Y khoa chuyên ngành Tâm thần học. 15 năm kinh nghiệm trong điều trị các bệnh lý tâm thần nghiêm trọng, rối loạn lo âu và trầm cảm. Giảng viên tại Đại học Y Dược TP.HCM.',800000.00,15,4.9,89),(3,9,'Tâm lý trẻ em và vị thành niên','Bác sĩ chuyên về tâm lý trẻ em và thanh thiếu niên. 8 năm kinh nghiệm hỗ trợ các vấn đề về học tập, hành vi và cảm xúc ở trẻ. Đã tham gia nhiều dự án can thiệp tâm lý tại trường học.',450000.00,8,4.7,156),(4,10,'Tư vấn tâm lý gia đình','Thạc sĩ tâm lý học chuyên về tư vấn gia đình và hôn nhân. 10 năm kinh nghiệm giúp đỡ các cặp vợ chồng và gia đình giải quyết xung đột, cải thiện mối quan hệ.',600000.00,10,4.6,78),(5,11,'Nghiên cứu tâm lý học','Phó Giáo sư, Tiến sĩ tâm lý học. Chuyên gia hàng đầu về nghiên cứu hành vi và nhận thức. 20 năm kinh nghiệm nghiên cứu và giảng dạy, tác giả nhiều công trình khoa học quốc tế.',1000000.00,20,4.9,45),(6,13,'Chưa cập nhật',NULL,0.00,0,0,0);
/*!40000 ALTER TABLE `doctor_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journal_entries`
--

DROP TABLE IF EXISTS `journal_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `journal_entries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_journal_user` (`user_id`),
  KEY `idx_journal_created` (`user_id`,`created_at`),
  CONSTRAINT `journal_entries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal_entries`
--

LOCK TABLES `journal_entries` WRITE;
/*!40000 ALTER TABLE `journal_entries` DISABLE KEYS */;
INSERT INTO `journal_entries` VALUES (1,1,'Hôm nay tôi hoàn thành được nhiều công việc. Tuy nhiên vẫn còn cảm giác áp lực về deadline sắp tới. Cần phải sắp xếp thời gian hợp lý hơn.','Một ngày bận rộn','2026-01-04 00:33:37','2026-01-05 00:33:37'),(2,1,'Tôi băn khoăn về hướng đi career của mình. Liệu có nên chuyển công việc? Cần thời gian để suy nghĩ kỹ hơn.','Suy nghĩ về tương lai','2026-01-02 00:33:37','2026-01-05 00:33:37'),(3,2,'Hôm nay tôi cảm thấy lo lắng vô cớ. Không rõ nguyên nhân nhưng tim cứ đập nhanh. May mắn đã tìm được bác sĩ để tư vấn.','Cảm xúc hôm nay','2026-01-03 00:33:37','2026-01-05 00:33:37'),(4,12,'Bbb',NULL,'2026-01-04 17:42:08','2026-01-04 17:42:08'),(5,12,'aaaa',NULL,'2026-01-05 04:30:55','2026-01-05 04:30:55');
/*!40000 ALTER TABLE `journal_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_chat_created` (`chat_id`,`created_at`),
  KEY `idx_sender` (`sender_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,1,1,'Chào bác sĩ, em muốn tư vấn về vấn đề stress trong công việc ạ.',1,'2025-12-29 00:33:37','2026-01-05 00:33:37'),(2,1,7,'Chào bạn! Bác sĩ rất sẵn lòng hỗ trợ. Bạn có thể chia sẻ cụ thể hơn về tình trạng hiện tại không?',1,'2025-12-29 00:43:37','2026-01-05 00:33:37'),(3,1,1,'Dạ em thường xuyên cảm thấy lo lắng và mất tập trung khi làm việc. Đêm cũng hay mất ngủ ạ.',1,'2025-12-29 00:58:37','2026-01-05 00:33:37'),(4,1,7,'Cảm ơn bạn đã chia sẻ. Những triệu chứng này khá phổ biến với stress công việc. Chúng ta nên đặt lịch gặp trực tiếp để tìm hiểu kỹ hơn nhé.',0,'2026-01-04 23:33:37','2026-01-05 00:33:37'),(5,2,2,'Bác sĩ ơi, gần đây tôi hay có cảm giác lo lắng vô cớ, tim đập nhanh.',1,'2025-12-31 00:33:37','2026-01-05 00:33:37'),(6,2,8,'Chào anh. Triệu chứng anh mô tả có thể liên quan đến rối loạn lo âu. Anh có thể kể thêm về thời điểm xuất hiện triệu chứng không?',1,'2025-12-31 01:33:37','2026-01-05 00:33:37'),(7,2,2,'Dạ thường xảy ra vào buổi tối trước khi đi ngủ, hoặc khi phải thuyết trình ạ.',0,'2026-01-04 22:33:37','2026-01-05 00:33:37'),(8,3,3,'Bác sĩ cho em hỏi, con em học lớp 8 gần đây hay cáu gắt và không chịu học hành.',1,'2026-01-02 00:33:37','2026-01-05 00:33:37'),(9,3,9,'Chào chị. Đây là dấu hiệu cần lưu ý ở tuổi vị thành niên. Chị có để ý thêm hành vi nào khác bất thường không?',1,'2026-01-02 01:03:37','2026-01-05 00:33:37'),(10,3,3,'Dạ có ạ, con cũng hay nhốt mình trong phòng và ít nói chuyện với gia đình hơn.',1,'2026-01-02 01:33:37','2026-01-05 00:33:37'),(11,3,9,'Cảm ơn chị đã chia sẻ. Tôi nghĩ nên có buổi gặp cả gia đình để hiểu rõ hơn tình hình. Chị có thể đặt lịch được không?',0,'2026-01-05 00:03:37','2026-01-05 00:33:37'),(12,4,5,'Chào bác sĩ, tôi và vợ đang có một số vấn đề trong giao tiếp, muốn được tư vấn ạ.',1,'2026-01-04 00:33:37','2026-01-05 00:33:37'),(13,4,10,'Chào anh. Rất vui được hỗ trợ anh. Anh có thể mô tả sơ qua về vấn đề chính không ạ?',1,'2026-01-04 01:33:37','2026-01-05 00:33:37'),(14,4,5,'Dạ chúng tôi hay có những cuộc tranh cãi về cách nuôi dạy con, và không ai chịu nghe ai cả.',0,'2026-01-05 00:23:37','2026-01-05 00:33:37'),(16,7,12,'Bzbc',0,'2026-01-04 18:44:55','2026-01-05 01:44:55'),(17,5,12,'Xin chào',0,'2026-01-04 18:47:28','2026-01-05 01:47:28'),(18,6,12,'Xin chào',0,'2026-01-04 18:48:36','2026-01-05 01:48:36'),(19,6,12,'Tôi tên là Tiến',0,'2026-01-04 18:48:46','2026-01-05 01:48:45'),(20,6,12,'Hôm nay tôi bị trầm cảm quá',0,'2026-01-04 18:49:01','2026-01-05 01:49:01'),(21,5,12,'Abcxyz',0,'2026-01-04 18:49:26','2026-01-05 01:49:25'),(22,5,12,'Hdhd',0,'2026-01-04 19:13:50','2026-01-05 02:13:50'),(23,5,12,'hello',0,'2026-01-05 04:31:36','2026-01-05 11:31:35'),(24,5,12,'hello',0,'2026-01-05 04:31:45','2026-01-05 11:31:44'),(25,5,12,'tien',0,'2026-01-05 04:38:31','2026-01-05 11:38:31'),(26,6,12,'zolo',0,'2026-01-05 04:39:31','2026-01-05 11:39:30'),(27,8,12,'hello',0,'2026-01-05 04:41:31','2026-01-05 11:41:30'),(28,5,12,'Hhhhh',0,'2026-01-05 05:35:53','2026-01-05 12:35:52'),(29,5,12,'Xin chao',0,'2026-01-05 05:37:56','2026-01-05 12:37:55'),(30,5,12,'Ggg',0,'2026-01-05 05:39:01','2026-01-05 12:39:00'),(31,5,12,'Y',0,'2026-01-05 05:39:18','2026-01-05 12:39:18'),(32,5,12,'bun qua',0,'2026-01-05 05:41:49','2026-01-05 12:41:49'),(33,5,12,'Yy',0,'2026-01-05 05:45:13','2026-01-05 12:45:13'),(34,5,12,'Ub',0,'2026-01-05 05:47:56','2026-01-05 12:47:56'),(35,5,12,'bjfbvjkdfbv',0,'2026-01-05 05:48:08','2026-01-05 12:48:07'),(36,5,12,'nnn',0,'2026-01-05 06:08:56','2026-01-05 13:08:56'),(37,5,12,'hh',0,'2026-01-05 06:31:45','2026-01-05 13:31:44'),(38,5,12,'zolo',0,'2026-01-05 06:43:44','2026-01-05 13:43:43'),(39,10,12,'hello',1,'2026-01-05 07:32:15','2026-01-05 22:26:12'),(40,10,12,'my name is tien',1,'2026-01-05 07:32:32','2026-01-05 22:26:12'),(41,10,12,'i have a problem',1,'2026-01-05 07:32:47','2026-01-05 22:26:12'),(42,10,12,'my score is so bad',1,'2026-01-05 07:33:00','2026-01-05 22:26:12'),(43,10,12,'i dont have enough to graduate',1,'2026-01-05 07:33:14','2026-01-05 22:26:12'),(44,10,12,'can you have me to solve that',1,'2026-01-05 07:33:27','2026-01-05 22:26:12'),(45,10,12,'hey',1,'2026-01-05 07:37:51','2026-01-05 22:26:12'),(46,10,12,'my name tien',1,'2026-01-05 07:48:16','2026-01-05 22:26:12'),(47,10,12,'n',1,'2026-01-05 07:56:17','2026-01-05 22:26:12'),(48,10,12,'U',1,'2026-01-05 08:01:07','2026-01-05 22:26:12'),(49,10,12,'H',1,'2026-01-05 08:05:13','2026-01-05 22:26:12'),(50,5,12,'aa',0,'2026-01-05 08:29:19','2026-01-05 15:29:19'),(51,5,12,'g',0,'2026-01-05 08:43:27','2026-01-05 15:43:26'),(52,10,13,'xin chao co viec gi',1,'2026-01-05 15:26:55','2026-01-05 22:33:09'),(53,10,12,'Rrrr',1,'2026-01-05 15:37:46','2026-01-05 23:03:37'),(54,10,12,'T',1,'2026-01-05 15:37:53','2026-01-05 23:03:37'),(55,10,12,'y',1,'2026-01-05 15:39:41','2026-01-05 23:03:37'),(56,10,12,'hom nay toi buon',1,'2026-01-05 15:52:22','2026-01-05 23:03:37'),(57,10,13,'tai sao',1,'2026-01-05 16:03:46','2026-01-05 23:08:37'),(58,10,12,'tai vay thoi chu bt sao',1,'2026-01-05 16:08:52','2026-01-05 23:15:05'),(59,10,13,'um',1,'2026-01-05 16:15:25','2026-01-05 23:19:26'),(60,10,12,'Ok',1,'2026-01-05 16:19:32','2026-01-05 23:23:03'),(61,10,12,'a',1,'2026-01-05 16:25:57','2026-01-05 23:33:25'),(62,10,13,'K',1,'2026-01-05 16:34:08','2026-01-05 23:40:22'),(63,10,12,'Hehe',1,'2026-01-05 16:40:28','2026-01-05 23:51:10'),(64,10,12,'Hmmm',1,'2026-01-05 16:59:52','2026-01-06 00:34:53'),(65,10,12,'Hey',1,'2026-01-05 17:26:03','2026-01-06 00:34:53'),(66,10,13,'Wut?',1,'2026-01-05 17:35:19','2026-01-06 00:35:40'),(67,10,12,'Hỏi tí',0,'2026-01-05 17:35:54','2026-01-06 00:35:54'),(68,11,14,'Hello',1,'2026-01-05 17:44:37','2026-01-06 00:46:55'),(69,11,13,'Sao v',0,'2026-01-05 17:47:06','2026-01-06 00:47:05');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mood_entries`
--

DROP TABLE IF EXISTS `mood_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mood_entries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `mood` enum('HAPPY','SAD','ANXIOUS','STRESSED','CALM','ANGRY','TIRED','EXCITED') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_created` (`user_id`,`created_at`),
  CONSTRAINT `mood_entries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mood_entries`
--

LOCK TABLES `mood_entries` WRITE;
/*!40000 ALTER TABLE `mood_entries` DISABLE KEYS */;
INSERT INTO `mood_entries` VALUES (1,1,'HAPPY','Hôm nay làm việc hiệu quả!','2026-01-04 00:33:37','2026-01-05 00:33:37'),(2,1,'CALM','Đi dạo công viên, thư giãn','2026-01-03 00:33:37','2026-01-05 00:33:37'),(3,1,'STRESSED','Deadline dự án gấp','2026-01-02 00:33:37','2026-01-05 00:33:37'),(4,2,'ANXIOUS','Lo lắng về công việc','2026-01-04 00:33:37','2026-01-05 00:33:37'),(5,3,'SAD','Con không chịu học','2026-01-03 00:33:37','2026-01-05 00:33:37'),(6,5,'TIRED','Làm việc mệt mỏi','2026-01-04 00:33:37','2026-01-05 00:33:37'),(8,12,'HAPPY',NULL,'2026-01-04 17:38:03','2026-01-05 00:38:02'),(9,12,'HAPPY',NULL,'2026-01-04 18:56:48','2026-01-05 01:56:48'),(10,12,'HAPPY',NULL,'2026-01-04 18:56:56','2026-01-05 01:56:56'),(11,12,'HAPPY',NULL,'2026-01-04 18:57:04','2026-01-05 01:57:03'),(12,12,'TIRED',NULL,'2026-01-04 18:59:04','2026-01-05 01:59:03'),(13,12,'SAD',NULL,'2026-01-04 18:59:25','2026-01-05 01:59:24'),(14,12,'TIRED',NULL,'2026-01-04 19:03:11','2026-01-05 02:03:11'),(15,12,'TIRED',NULL,'2026-01-04 19:05:25','2026-01-05 02:05:25'),(16,12,'EXCITED',NULL,'2026-01-04 19:06:28','2026-01-05 02:06:28'),(17,12,'ANGRY',NULL,'2026-01-04 19:08:34','2026-01-05 02:08:33'),(18,12,'SAD',NULL,'2026-01-04 19:12:28','2026-01-05 02:12:27'),(19,12,'STRESSED',NULL,'2026-01-04 19:12:35','2026-01-05 02:12:35'),(20,12,'HAPPY',NULL,'2026-01-04 19:12:43','2026-01-05 02:12:42'),(21,12,'ANGRY',NULL,'2026-01-05 04:31:11','2026-01-05 11:31:11'),(22,12,'STRESSED',NULL,'2026-01-05 05:41:33','2026-01-05 12:41:32'),(23,12,'HAPPY',NULL,'2026-01-05 17:07:29','2026-01-06 00:07:29'),(24,12,'HAPPY',NULL,'2026-01-05 17:07:34','2026-01-06 00:07:33'),(25,12,'HAPPY',NULL,'2026-01-05 17:07:53','2026-01-06 00:07:52'),(26,12,'EXCITED',NULL,'2026-01-05 17:10:22','2026-01-06 00:10:21'),(27,12,'EXCITED',NULL,'2026-01-05 17:10:25','2026-01-06 00:10:24'),(28,14,'TIRED',NULL,'2026-01-05 17:44:09','2026-01-06 00:44:09');
/*!40000 ALTER TABLE `mood_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hashed_password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('PATIENT','DOCTOR') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'a@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','Test User','0901234567',NULL,'PATIENT',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(2,'nguyen.vana@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','Nguyễn Văn An','0912345678','https://i.pravatar.cc/150?img=11','PATIENT',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(3,'tran.thib@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','Trần Thị Bích','0912345679','https://i.pravatar.cc/150?img=5','PATIENT',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(4,'le.hoangc@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','Lê Hoàng Châu','0923456789','https://i.pravatar.cc/150?img=12','PATIENT',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(5,'pham.minhtien@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','Phạm Minh Tiến','0934567890','https://i.pravatar.cc/150?img=13','PATIENT',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(6,'vo.thue@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','Võ Thu Ế','0945678901','https://i.pravatar.cc/150?img=9','PATIENT',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(7,'dr.nguyenthanhf@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','BS. Nguyễn Thanh Phong','0912111111','https://i.pravatar.cc/150?img=33','DOCTOR',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(8,'dr.tranthig@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','TS. Trần Thị Giang','0912222222','https://i.pravatar.cc/150?img=44','DOCTOR',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(9,'dr.levanhung@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','BS. Lê Văn Hùng','0912333333','https://i.pravatar.cc/150?img=14','DOCTOR',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(10,'dr.phamthii@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','ThS. Phạm Thị Hoa','0912444444','https://i.pravatar.cc/150?img=47','DOCTOR',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(11,'dr.hoangtank@gmail.com','$pbkdf2-sha256$30000$BiAkZCzlvHeOcW5tLcV47w$M/.QBhhM8dRe91BULcfOoaeyuGmSVRgs91kvt4nOi3s','PGS.TS. Hoàng Tấn Khoa','0912555555','https://i.pravatar.cc/150?img=52','DOCTOR',1,'2026-01-04 17:33:37','2026-01-04 17:33:37'),(12,'randy2032005@gmail.com','$pbkdf2-sha256$30000$yPkfI8RYC0EoZYxxjpFSag$R8abWUD2.Wk55cN3RI8CSVS8vYaY0hdjDekj5MAwqa8','Huỳnh Minh Tiến','0123456789',NULL,'PATIENT',1,'2026-01-04 17:37:43','2026-01-04 17:37:43'),(13,'doctor@gmail.com','$pbkdf2-sha256$30000$4VwrpXQuJUTIWSslJGQspQ$6k1apVvBznIb2Pn8U8NF7EOAnvpb82Uicvj3OufB/jQ','doctor','0123456789',NULL,'DOCTOR',1,'2026-01-05 07:01:48','2026-01-05 07:01:48'),(14,'abc@gmail.com','$pbkdf2-sha256$30000$cY6REsJ4j7H23nvv/X.PMQ$OnWacGJsnjPjreItU/T8avPYMkNzBciBRfmXiq.kAH0','Tiến','0123456789',NULL,'PATIENT',1,'2026-01-05 17:40:36','2026-01-05 17:40:36');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_user_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    IF NEW.role = 'DOCTOR' THEN
        INSERT INTO doctor_profiles (user_id, specialization)
        VALUES (NEW.id, 'Chưa cập nhật');
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vw_doctor_details`
--

DROP TABLE IF EXISTS `vw_doctor_details`;
/*!50001 DROP VIEW IF EXISTS `vw_doctor_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_doctor_details` AS SELECT 
 1 AS `id`,
 1 AS `email`,
 1 AS `full_name`,
 1 AS `phone_number`,
 1 AS `avatar`,
 1 AS `created_at`,
 1 AS `specialization`,
 1 AS `bio`,
 1 AS `consultation_fee`,
 1 AS `years_of_experience`,
 1 AS `rating`,
 1 AS `review_count`,
 1 AS `total_appointments`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'bemindcare'
--

--
-- Dumping routines for database 'bemindcare'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetDoctorAppointments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDoctorAppointments`(IN p_doctor_id INT, IN p_date DATE)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_doctor_details`
--

/*!50001 DROP VIEW IF EXISTS `vw_doctor_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_doctor_details` AS select `u`.`id` AS `id`,`u`.`email` AS `email`,`u`.`full_name` AS `full_name`,`u`.`phone_number` AS `phone_number`,`u`.`avatar` AS `avatar`,`u`.`created_at` AS `created_at`,`dp`.`specialization` AS `specialization`,`dp`.`bio` AS `bio`,`dp`.`consultation_fee` AS `consultation_fee`,`dp`.`years_of_experience` AS `years_of_experience`,`dp`.`rating` AS `rating`,`dp`.`review_count` AS `review_count`,(select count(0) from `appointments` `a` where (`a`.`doctor_id` = `u`.`id`)) AS `total_appointments` from (`users` `u` join `doctor_profiles` `dp` on((`u`.`id` = `dp`.`user_id`))) where (`u`.`role` = 'DOCTOR') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-06  1:05:41
