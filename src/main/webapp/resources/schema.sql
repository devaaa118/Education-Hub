-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: education_hub
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `class_subjects`
--

DROP TABLE IF EXISTS `class_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_subjects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_id` bigint NOT NULL,
  `subject_id` bigint NOT NULL,
  `stream_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_class_subject_stream` (`class_id`,`subject_id`,`stream_id`),
  KEY `subject_id` (`subject_id`),
  KEY `stream_id` (`stream_id`),
  CONSTRAINT `class_subjects_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `class_subjects_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  CONSTRAINT `class_subjects_ibfk_3` FOREIGN KEY (`stream_id`) REFERENCES `streams` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_subjects`
--

LOCK TABLES `class_subjects` WRITE;
/*!40000 ALTER TABLE `class_subjects` DISABLE KEYS */;
INSERT INTO `class_subjects` VALUES (1,1,1,NULL),(2,1,2,NULL),(3,1,3,NULL),(4,1,4,NULL),(5,1,11,NULL),(6,1,12,NULL),(7,2,1,NULL),(8,2,2,NULL),(9,2,3,NULL),(10,2,4,NULL),(11,2,11,NULL),(12,2,12,NULL),(13,3,1,NULL),(14,3,2,NULL),(15,3,3,NULL),(16,3,4,NULL),(17,3,11,NULL),(18,3,12,NULL),(19,4,1,NULL),(20,4,2,NULL),(21,4,3,NULL),(22,4,4,NULL),(23,4,11,NULL),(24,4,12,NULL),(25,5,1,NULL),(26,5,2,NULL),(27,5,3,NULL),(28,5,4,NULL),(29,5,11,NULL),(30,5,12,NULL),(31,6,1,NULL),(32,6,2,NULL),(33,6,3,NULL),(34,6,5,NULL),(35,6,6,NULL),(36,6,11,NULL),(37,6,12,NULL),(38,7,1,NULL),(39,7,2,NULL),(40,7,3,NULL),(41,7,5,NULL),(42,7,6,NULL),(43,7,11,NULL),(44,7,12,NULL),(45,8,1,NULL),(46,8,2,NULL),(47,8,3,NULL),(48,8,5,NULL),(49,8,6,NULL),(50,8,11,NULL),(51,8,12,NULL),(52,9,1,NULL),(53,9,2,NULL),(54,9,3,NULL),(55,9,5,NULL),(56,9,6,NULL),(57,9,11,NULL),(58,9,12,NULL),(59,10,1,NULL),(60,10,2,NULL),(61,10,3,NULL),(62,10,5,NULL),(63,10,6,NULL),(64,10,11,NULL),(65,10,12,NULL),(82,11,1,2),(92,11,1,3),(81,11,2,2),(91,11,2,3),(66,11,3,1),(67,11,5,1),(68,11,7,1),(69,11,8,1),(70,11,9,1),(71,11,10,1),(78,11,13,2),(79,11,14,2),(80,11,15,2),(88,11,16,3),(89,11,17,3),(90,11,18,3),(87,12,1,2),(97,12,1,3),(86,12,2,2),(96,12,2,3),(72,12,3,1),(73,12,5,1),(74,12,7,1),(75,12,8,1),(76,12,9,1),(77,12,10,1),(83,12,13,2),(84,12,14,2),(85,12,15,2),(93,12,16,3),(94,12,17,3),(95,12,18,3);
/*!40000 ALTER TABLE `class_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` VALUES (1,'Class 1'),(2,'Class 2'),(3,'Class 3'),(4,'Class 4'),(5,'Class 5'),(6,'Class 6'),(7,'Class 7'),(8,'Class 8'),(9,'Class 9'),(10,'Class 10'),(11,'Class 11'),(12,'Class 12');
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_id` bigint NOT NULL,
  `subject_id` bigint NOT NULL,
  `title` varchar(255) NOT NULL,
  `file_link` varchar(500) NOT NULL,
  `type` enum('PDF','Video','Quiz') NOT NULL,
  `language` enum('Tamil','English') NOT NULL,
  `uploaded_by` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `stream_id` bigint DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '1',
  `verified_by` bigint DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `subject_id` (`subject_id`),
  KEY `uploaded_by` (`uploaded_by`),
  KEY `fk_resources_stream` (`stream_id`),
  KEY `fk_resources_verified_by` (`verified_by`),
  CONSTRAINT `fk_resources_stream` FOREIGN KEY (`stream_id`) REFERENCES `streams` (`id`),
  CONSTRAINT `fk_resources_verified_by` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`),
  CONSTRAINT `resources_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `resources_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  CONSTRAINT `resources_ibfk_3` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources`
--

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;
INSERT INTO `resources` VALUES
(4,2,1,'IOTT','WEB-INF/uploads/b255fced-77da-4605-84b6-b045b6f8d6d8_FALLSEM2025-26_ECE3501_ELA_CH2025260101229_2025-09-23_Reference-Material-I.pdf','PDF','English',3,'2025-09-23 18:39:18',NULL,1,3,'2025-09-23 18:40:00'),
(6,4,2,'IOT','uploads/05b2287d-15f7-448d-8712-43eca104c465_FALLSEM2025-26_ECE3501_ELA_CH2025260101229_2025-09-23_Reference-Material-I.pdf','PDF','English',3,'2025-09-23 18:55:12',NULL,1,3,'2025-09-23 18:56:10'),
(7,7,1,'Tamil pdf','uploads/e3f38b3f-eb73-47e7-b974-43b649f80f1e_DEEPUI VISUAL TESTING IEEE PAPER (2).pdf','PDF','Tamil',3,'2025-09-24 04:39:05',NULL,1,3,'2025-09-24 04:40:00'),
(8,5,2,'SPM','uploads/466cfeeb-7e50-4783-b032-1c71f2e4df21_Testing Strategies and tatics.pdf','PDF','English',3,'2025-09-24 06:59:44',NULL,1,3,'2025-09-24 07:01:00'),
(9,10,5,'science resource','uploads/c4a125b1-68b5-443d-b68d-f35299552869_Software Test Estimation Techniques.pdf','PDF','English',3,'2025-09-26 07:36:26',NULL,1,3,'2025-09-26 07:37:30');
/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `streams`
--

DROP TABLE IF EXISTS `streams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `streams` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `stream_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`stream_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `streams`
--

LOCK TABLES `streams` WRITE;
/*!40000 ALTER TABLE `streams` DISABLE KEYS */;
INSERT INTO `streams` VALUES (3,'Arts'),(2,'Commerce'),(1,'Science');
/*!40000 ALTER TABLE `streams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resource_progress`
--

DROP TABLE IF EXISTS `resource_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resource_progress` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `resource_id` bigint NOT NULL,
  `status` enum('NOT_STARTED','IN_PROGRESS','COMPLETED') NOT NULL DEFAULT 'NOT_STARTED',
  `notes` varchar(500) DEFAULT NULL,
  `last_viewed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_progress_student_resource` (`student_id`,`resource_id`),
  KEY `fk_resource_progress_resource` (`resource_id`),
  CONSTRAINT `fk_resource_progress_resource` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_resource_progress_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resource_progress`
--

LOCK TABLES `resource_progress` WRITE;
/*!40000 ALTER TABLE `resource_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `resource_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tutoring_sessions`
--

DROP TABLE IF EXISTS `tutoring_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tutoring_sessions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text,
  `tutor_name` varchar(120) NOT NULL,
  `session_datetime` datetime NOT NULL,
  `class_id` bigint DEFAULT NULL,
  `subject_id` bigint DEFAULT NULL,
  `meeting_link` varchar(500) DEFAULT NULL,
  `created_by` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_tutoring_class` (`class_id`),
  KEY `fk_tutoring_subject` (`subject_id`),
  KEY `fk_tutoring_creator` (`created_by`),
  CONSTRAINT `fk_tutoring_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `fk_tutoring_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_tutoring_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tutoring_sessions`
--

LOCK TABLES `tutoring_sessions` WRITE;
/*!40000 ALTER TABLE `tutoring_sessions` DISABLE KEYS */;
INSERT INTO `tutoring_sessions` (`title`,`description`,`tutor_name`,`session_datetime`,`class_id`,`subject_id`,`meeting_link`,`created_by`)
VALUES
('Weekly Math Doubt Clinic','Open Q&A focused on algebra and geometry problem solving.','Mr. Karthik','2025-10-05 17:00:00',9,3,'https://meet.example.com/math-algebra',3),
('Tamil Literature Deep Dive','Discussing short stories from the state board syllabus.','Ms. Lakshmi','2025-10-06 18:30:00',7,1,'https://meet.example.com/tamil-literature',3);
/*!40000 ALTER TABLE `tutoring_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizzes`
--

DROP TABLE IF EXISTS `quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quizzes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text,
  `class_id` bigint NOT NULL,
  `subject_id` bigint NOT NULL,
  `language` enum('Tamil','English') NOT NULL DEFAULT 'English',
  `time_limit_minutes` int DEFAULT NULL,
  `created_by` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_quiz_class` (`class_id`),
  KEY `fk_quiz_subject` (`subject_id`),
  KEY `fk_quiz_creator` (`created_by`),
  CONSTRAINT `fk_quiz_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `fk_quiz_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  CONSTRAINT `fk_quiz_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quiz_questions`
--

DROP TABLE IF EXISTS `quiz_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_questions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quiz_id` bigint NOT NULL,
  `question_text` text NOT NULL,
  `option_a` varchar(255) NOT NULL,
  `option_b` varchar(255) NOT NULL,
  `option_c` varchar(255) NOT NULL,
  `option_d` varchar(255) NOT NULL,
  `correct_option` char(1) NOT NULL,
  `marks` int DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_question_quiz` (`quiz_id`),
  CONSTRAINT `fk_question_quiz` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quiz_attempts`
--

DROP TABLE IF EXISTS `quiz_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_attempts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quiz_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `score` int NOT NULL,
  `total_questions` int NOT NULL,
  `correct_answers` int NOT NULL,
  `responses_json` text,
  `attempted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_attempt_quiz` (`quiz_id`),
  KEY `fk_attempt_student` (`student_id`),
  CONSTRAINT `fk_attempt_quiz` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_attempt_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_classes`
--

DROP TABLE IF EXISTS `student_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_classes` (
  `student_id` bigint NOT NULL,
  `class_id` bigint NOT NULL,
  `stream_id` int DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `student_classes_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `student_classes_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_classes`
--

LOCK TABLES `student_classes` WRITE;
/*!40000 ALTER TABLE `student_classes` DISABLE KEYS */;
INSERT INTO `student_classes` VALUES (2,1,NULL),(4,10,NULL),(5,10,NULL),(7,10,NULL),(8,5,NULL),(9,3,NULL),(10,8,NULL),(25,11,NULL),(26,11,1);
/*!40000 ALTER TABLE `student_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `subject_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,'Tamil'),(2,'English'),(3,'Mathematics'),(4,'Environmental Science'),(5,'Science'),(6,'Social Science'),(7,'Physics'),(8,'Chemistry'),(9,'Biology'),(10,'Computer Science'),(11,'Physical Education'),(12,'Arts'),(13,'Economics'),(14,'Accountancy'),(15,'Business Studies'),(16,'History'),(17,'Geography'),(18,'Political Science');
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('student','teacher','admin') DEFAULT 'student',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `stream_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_user_stream` (`stream_id`),
  CONSTRAINT `fk_user_stream` FOREIGN KEY (`stream_id`) REFERENCES `streams` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'22mis1071','Devaram S','devarams569@gmail.comm','deadwada','student','2025-09-15 11:51:59','2025-09-15 11:51:59',NULL),(3,'Agaran@123','Agaran','agaran@gmail.com','agaran1234','teacher','2025-09-15 16:15:54','2025-09-15 16:15:54',NULL),(4,'Sai@123','Sai Krishnaa','saikrishnaab12b319@gmail.com','sai12345','student','2025-09-15 17:44:27','2025-09-15 17:44:27',NULL),(5,'Kumar123','Kumaran','kumar@gmail.com','kumar123','student','2025-09-15 17:48:04','2025-09-15 17:48:04',NULL),(7,'arun@123','arun','arun@gmail.com','arun1234','student','2025-09-15 17:54:46','2025-09-15 17:54:46',NULL),(8,'Atharva123','Atharva@123','atharvagholp205@gmai.com','atharva123','student','2025-09-17 05:15:53','2025-09-17 05:15:53',NULL),(9,'Vishal@123','Vishal S','vishal@gmail.com','vishal1234','student','2025-09-24 05:39:43','2025-09-24 05:39:43',NULL),(10,'Vijay@123','Vijay','vijay@gmail.com','vijay@123','student','2025-09-24 05:43:25','2025-09-24 05:43:25',NULL),(25,'onelasttime','onelasttime','onelast@gmail.com','onelast123','student','2025-09-25 16:45:13','2025-09-25 16:45:13',NULL),(26,'surelast','sure last time','surelast@gmail.com','stud1234','student','2025-09-25 17:12:25','2025-09-25 17:12:25',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-27 18:39:31
