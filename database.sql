-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: student_login
-- ------------------------------------------------------
-- Server version	9.6.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '693669f1-0cda-11f1-b2c9-1cce51f67ac6:1-166';

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7','admin@college.edu');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessment_master`
--

DROP TABLE IF EXISTS `assessment_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_master` (
  `assessment_id` int NOT NULL AUTO_INCREMENT,
  `assessment_name` varchar(50) NOT NULL,
  `max_marks` int NOT NULL,
  PRIMARY KEY (`assessment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_master`
--

LOCK TABLES `assessment_master` WRITE;
/*!40000 ALTER TABLE `assessment_master` DISABLE KEYS */;
INSERT INTO `assessment_master` VALUES (1,'Mid-1',20),(2,'Mid-2',20),(3,'Assignment-1',10),(4,'Assignment-2',10),(5,'Lab Internal',30),(6,'Semester Exam',100);
/*!40000 ALTER TABLE `assessment_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` varchar(20) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `classes_present` int DEFAULT '0',
  `total_classes` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_details`
--

DROP TABLE IF EXISTS `attendance_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `student_id` varchar(30) NOT NULL,
  `student_name` varchar(100) NOT NULL,
  `attendance_status` enum('Present','Absent') DEFAULT 'Absent',
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `attendance_details_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `attendance_session` (`session_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_details`
--

LOCK TABLES `attendance_details` WRITE;
/*!40000 ALTER TABLE `attendance_details` DISABLE KEYS */;
INSERT INTO `attendance_details` VALUES (1,1,'CSE23001','Rahul Kumar','Present'),(2,1,'CSE23002','Sai Krishna','Present'),(3,1,'CSE23003','Akhil Reddy','Present'),(4,1,'CSE23004','Kiran Kumar','Absent'),(5,1,'CSE23005','Harsha Vardhan','Absent'),(6,1,'CSE23006','Vamsi Krishna','Absent'),(7,1,'CSE23007','Teja Kumar','Present'),(8,1,'CSE23008','Charan Reddy','Present'),(9,1,'CSE23009','Pavan Kumar','Present'),(10,1,'CSE23010','Nikhil Sai','Absent'),(11,1,'CSE23011','Arjun Varma','Absent'),(12,1,'CSE23012','Manoj Kumar','Absent'),(13,1,'CSE23013','Rohit Sharma','Absent'),(14,1,'CSE23014','Abhishek Reddy','Present'),(15,1,'CSE23015','Karthik Sai','Present'),(16,1,'CSE23016','Naveen Kumar','Present'),(17,1,'CSE23017','Lokesh Reddy','Absent'),(18,1,'CSE23018','Vijay Krishna','Present'),(19,1,'CSE23019','Ajay Kumar','Absent'),(20,1,'CSE23020','Sandeep Varma','Present'),(21,2,'CSE23001','Rahul Kumar','Present'),(22,2,'CSE23002','Sai Krishna','Present'),(23,2,'CSE23003','Akhil Reddy','Present'),(24,2,'CSE23004','Kiran Kumar','Present'),(25,2,'CSE23005','Harsha Vardhan','Present'),(26,2,'CSE23006','Vamsi Krishna','Present'),(27,2,'CSE23007','Teja Kumar','Present'),(28,2,'CSE23008','Charan Reddy','Present'),(29,2,'CSE23009','Pavan Kumar','Present'),(30,2,'CSE23010','Nikhil Sai','Present'),(31,2,'CSE23011','Arjun Varma','Present'),(32,2,'CSE23012','Manoj Kumar','Present'),(33,2,'CSE23013','Rohit Sharma','Present'),(34,2,'CSE23014','Abhishek Reddy','Present'),(35,2,'CSE23015','Karthik Sai','Present'),(36,2,'CSE23016','Naveen Kumar','Present'),(37,2,'CSE23017','Lokesh Reddy','Present'),(38,2,'CSE23018','Vijay Krishna','Present'),(39,2,'CSE23019','Ajay Kumar','Present'),(40,2,'CSE23020','Sandeep Varma','Present'),(41,3,'AI23021','Aditya Verma','Present'),(42,3,'AI23022','Rohan Gupta','Present'),(43,3,'AI23023','Vivek Sharma','Present'),(44,3,'AI23024','Karthik Reddy','Absent'),(45,3,'AI23025','Arun Kumar','Absent'),(46,3,'AI23026','Naveen Sai','Absent'),(47,3,'AI23027','Harish Kumar','Absent'),(48,3,'AI23028','Lokesh Varma','Present'),(49,3,'AI23029','Pavan Krishna','Present'),(50,3,'AI23030','Surya Teja','Absent'),(51,3,'AI23031','Pranav Kumar','Present'),(52,3,'AI23032','Varun Reddy','Absent'),(53,3,'AI23033','Aravind Sai','Present'),(54,3,'AI23034','Vishal Gupta','Absent'),(55,3,'AI23035','Nithin Kumar','Present'),(56,3,'AI23036','Rohit Verma','Present'),(57,3,'AI23037','Harsha Kumar','Present'),(58,3,'AI23038','Koushik Reddy','Present'),(59,3,'AI23039','Sachin Kumar','Absent'),(60,3,'AI23040','Yash Sharma','Absent'),(61,4,'CSE23001','Rahul Kumar','Present'),(62,4,'CSE23002','Sai Krishna','Present'),(63,4,'CSE23003','Akhil Reddy','Present'),(64,4,'CSE23004','Kiran Kumar','Present'),(65,4,'CSE23005','Harsha Vardhan','Present'),(66,4,'CSE23006','Vamsi Krishna','Present'),(67,4,'CSE23007','Teja Kumar','Present'),(68,4,'CSE23008','Charan Reddy','Present'),(69,4,'CSE23009','Pavan Kumar','Present'),(70,4,'CSE23010','Nikhil Sai','Present'),(71,4,'CSE23011','Arjun Varma','Present'),(72,4,'CSE23012','Manoj Kumar','Present'),(73,4,'CSE23013','Rohit Sharma','Present'),(74,4,'CSE23014','Abhishek Reddy','Present'),(75,4,'CSE23015','Karthik Sai','Present'),(76,4,'CSE23016','Naveen Kumar','Present'),(77,4,'CSE23017','Lokesh Reddy','Present'),(78,4,'CSE23018','Vijay Krishna','Present'),(79,4,'CSE23019','Ajay Kumar','Present'),(80,4,'CSE23020','Sandeep Varma','Present');
/*!40000 ALTER TABLE `attendance_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_edit_log`
--

DROP TABLE IF EXISTS `attendance_edit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_edit_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `student_id` varchar(30) DEFAULT NULL,
  `old_status` varchar(10) DEFAULT NULL,
  `new_status` varchar(10) DEFAULT NULL,
  `edited_by` varchar(20) DEFAULT NULL,
  `reason` text,
  `edited_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_edit_log`
--

LOCK TABLES `attendance_edit_log` WRITE;
/*!40000 ALTER TABLE `attendance_edit_log` DISABLE KEYS */;
INSERT INTO `attendance_edit_log` VALUES (1,1,'CSE23003','Absent','Present','FAC002','Voice not audible ','2026-08-01 18:31:02');
/*!40000 ALTER TABLE `attendance_edit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_session`
--

DROP TABLE IF EXISTS `attendance_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_session` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `faculty_id` varchar(20) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `semester` int NOT NULL,
  `section` varchar(10) NOT NULL,
  `slot` varchar(20) NOT NULL,
  `attendance_date` date NOT NULL,
  `total_students` int NOT NULL,
  `present_students` int DEFAULT '0',
  `absent_students` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`),
  KEY `faculty_id` (`faculty_id`),
  CONSTRAINT `attendance_session_ibfk_1` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`faculty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_session`
--

LOCK TABLES `attendance_session` WRITE;
/*!40000 ALTER TABLE `attendance_session` DISABLE KEYS */;
INSERT INTO `attendance_session` VALUES (1,'FAC002','Database Management Systems',3,'A','A2','2026-08-01',20,11,9,'2026-08-01 18:30:28'),(2,'FAC001','Data Structures',3,'A','A1','2026-08-01',20,20,0,'2026-08-01 19:26:31'),(3,'FAC004','Artificial Intelligence',3,'B','B1','2026-08-01',20,11,9,'2026-08-01 20:20:33'),(4,'FAC003','Operating Systems',3,'A','A3','2026-08-01',20,20,0,'2026-08-01 20:24:14');
/*!40000 ALTER TABLE `attendance_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_materials`
--

DROP TABLE IF EXISTS `course_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_materials` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faculty_id` varchar(20) DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `description` text,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_materials`
--

LOCK TABLES `course_materials` WRITE;
/*!40000 ALTER TABLE `course_materials` DISABLE KEYS */;
INSERT INTO `course_materials` VALUES (11,'FAC002','Database Management Systems','Module 1','Part 1','MODULE-1 PART-1.pdf','uploads/materials/MODULE-1 PART-1.pdf','2026-08-01 18:44:40'),(13,'FAC001','Data Structures','Module 1','Asymptotic Notations','Module 1_2 - Asymptotic notation.pptx','uploads/materials/Module 1_2 - Asymptotic notation.pptx','2026-08-01 19:43:36');
/*!40000 ALTER TABLE `course_materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) NOT NULL,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_name` (`department_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (2,'Artificial Intelligence'),(6,'Civil Engineering'),(1,'Computer Science Engineering'),(4,'Electrical and Electronics Engineering'),(3,'Electronics and Communication Engineering'),(5,'Mechanical Engineering');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty` (
  `faculty_id` varchar(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`faculty_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty`
--

LOCK TABLES `faculty` WRITE;
/*!40000 ALTER TABLE `faculty` DISABLE KEYS */;
INSERT INTO `faculty` VALUES ('FAC001','FAC001','ramesh@gmail.com','9859bcef2187144a16f11447b17129443780817a119496650b96bf354a65739e','Dr. Ramesh Kumar','9876543210','Computer Science Engineering','Assistant Professor'),('FAC002','FAC002','srinivas.rao@faculty.college.edu','9859bcef2187144a16f11447b17129443780817a119496650b96bf354a65739e','Dr. Srinivas Rao','9876510002','Computer Science Engineering','Associate Professor'),('FAC003','FAC003','vinay.kumar@faculty.college.edu','9859bcef2187144a16f11447b17129443780817a119496650b96bf354a65739e','Dr. Vinay Kumar','9876510003','Computer Science Engineering','Assistant Professor'),('FAC004','FAC004','priya.nair@faculty.college.edu','9859bcef2187144a16f11447b17129443780817a119496650b96bf354a65739e','Dr. Priya Nair','9876510004','Artificial Intelligence','Assistant Professor'),('FAC005','FAC005','anil.reddy@faculty.college.edu','9859bcef2187144a16f11447b17129443780817a119496650b96bf354a65739e','Dr. Anil Reddy','9876510005','Electronics and Communication Engineering','Associate Professor'),('FAC006','FAC006','meera.iyer@faculty.college.edu','9859bcef2187144a16f11447b17129443780817a119496650b96bf354a65739e','Dr. Meera Iyer','9876510006','Electronics and Communication Engineering','Professor');
/*!40000 ALTER TABLE `faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty_assignments`
--

DROP TABLE IF EXISTS `faculty_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty_assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faculty_id` varchar(20) NOT NULL,
  `department` varchar(100) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `semester` int NOT NULL,
  `section` varchar(10) NOT NULL,
  `slot` varchar(20) NOT NULL,
  `total_students` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `faculty_id` (`faculty_id`),
  CONSTRAINT `faculty_assignments_ibfk_1` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`faculty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty_assignments`
--

LOCK TABLES `faculty_assignments` WRITE;
/*!40000 ALTER TABLE `faculty_assignments` DISABLE KEYS */;
INSERT INTO `faculty_assignments` VALUES (1,'FAC001','Computer Science Engineering','Data Structures',3,'A','A1',20),(2,'FAC002','Computer Science Engineering','Database Management Systems',3,'A','A2',20),(3,'FAC003','Computer Science Engineering','Operating Systems',3,'A','A3',20),(4,'FAC004','Artificial Intelligence','Artificial Intelligence',3,'B','B1',20),(5,'FAC005','Electronics and Communication Engineering','Digital Electronics',3,'C','C1',20),(6,'FAC006','Electronics and Communication Engineering','Signals and Systems',3,'C','C2',20);
/*!40000 ALTER TABLE `faculty_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marks`
--

DROP TABLE IF EXISTS `marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` varchar(20) DEFAULT NULL,
  `semester` int DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `mid1` int DEFAULT NULL,
  `mid2` int DEFAULT NULL,
  `internal_marks` int DEFAULT NULL,
  `final_exam` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_student_marks` (`student_id`),
  CONSTRAINT `fk_student_marks` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marks`
--

LOCK TABLES `marks` WRITE;
/*!40000 ALTER TABLE `marks` DISABLE KEYS */;
/*!40000 ALTER TABLE `marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marks_details`
--

DROP TABLE IF EXISTS `marks_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marks_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `student_name` varchar(100) NOT NULL,
  `marks` decimal(5,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `marks_details_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `marks_session` (`session_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marks_details`
--

LOCK TABLES `marks_details` WRITE;
/*!40000 ALTER TABLE `marks_details` DISABLE KEYS */;
INSERT INTO `marks_details` VALUES (1,1,'CSE23001','Rahul Kumar',10.00),(2,1,'CSE23002','Sai Krishna',15.00),(3,1,'CSE23003','Akhil Reddy',16.00),(4,1,'CSE23004','Kiran Kumar',10.00),(5,1,'CSE23005','Harsha Vardhan',7.00),(6,1,'CSE23006','Vamsi Krishna',18.00),(7,1,'CSE23007','Teja Kumar',19.00),(8,1,'CSE23008','Charan Reddy',7.00),(9,1,'CSE23009','Pavan Kumar',5.00),(10,1,'CSE23010','Nikhil Sai',20.00),(11,1,'CSE23011','Arjun Varma',14.00),(12,1,'CSE23012','Manoj Kumar',14.00),(13,1,'CSE23013','Rohit Sharma',11.00),(14,1,'CSE23014','Abhishek Reddy',12.00),(15,1,'CSE23015','Karthik Sai',12.00),(16,1,'CSE23016','Naveen Kumar',20.00),(17,1,'CSE23017','Lokesh Reddy',20.00),(18,1,'CSE23018','Vijay Krishna',20.00),(19,1,'CSE23019','Ajay Kumar',20.00),(20,1,'CSE23020','Sandeep Varma',20.00),(21,2,'CSE23001','Rahul Kumar',20.00),(22,2,'CSE23002','Sai Krishna',10.00),(23,2,'CSE23003','Akhil Reddy',15.00),(24,2,'CSE23004','Kiran Kumar',14.00),(25,2,'CSE23005','Harsha Vardhan',1.00),(26,2,'CSE23006','Vamsi Krishna',2.00),(27,2,'CSE23007','Teja Kumar',20.00),(28,2,'CSE23008','Charan Reddy',14.00),(29,2,'CSE23009','Pavan Kumar',15.00),(30,2,'CSE23010','Nikhil Sai',16.00),(31,2,'CSE23011','Arjun Varma',10.00),(32,2,'CSE23012','Manoj Kumar',9.00),(33,2,'CSE23013','Rohit Sharma',8.00),(34,2,'CSE23014','Abhishek Reddy',4.00),(35,2,'CSE23015','Karthik Sai',12.00),(36,2,'CSE23016','Naveen Kumar',17.00),(37,2,'CSE23017','Lokesh Reddy',16.00),(38,2,'CSE23018','Vijay Krishna',12.00),(39,2,'CSE23019','Ajay Kumar',14.00),(40,2,'CSE23020','Sandeep Varma',15.00),(41,3,'CSE23001','Rahul Kumar',10.00),(42,3,'CSE23002','Sai Krishna',15.00),(43,3,'CSE23003','Akhil Reddy',14.00),(44,3,'CSE23004','Kiran Kumar',11.00),(45,3,'CSE23005','Harsha Vardhan',12.00),(46,3,'CSE23006','Vamsi Krishna',13.00),(47,3,'CSE23007','Teja Kumar',14.00),(48,3,'CSE23008','Charan Reddy',15.00),(49,3,'CSE23009','Pavan Kumar',10.00),(50,3,'CSE23010','Nikhil Sai',9.00),(51,3,'CSE23011','Arjun Varma',8.00),(52,3,'CSE23012','Manoj Kumar',7.00),(53,3,'CSE23013','Rohit Sharma',6.00),(54,3,'CSE23014','Abhishek Reddy',5.00),(55,3,'CSE23015','Karthik Sai',4.00),(56,3,'CSE23016','Naveen Kumar',1.00),(57,3,'CSE23017','Lokesh Reddy',2.00),(58,3,'CSE23018','Vijay Krishna',2.00),(59,3,'CSE23019','Ajay Kumar',12.00),(60,3,'CSE23020','Sandeep Varma',20.00),(61,4,'CSE23001','Rahul Kumar',0.00),(62,4,'CSE23002','Sai Krishna',0.00),(63,4,'CSE23003','Akhil Reddy',0.00),(64,4,'CSE23004','Kiran Kumar',0.00),(65,4,'CSE23005','Harsha Vardhan',0.00),(66,4,'CSE23006','Vamsi Krishna',0.00),(67,4,'CSE23007','Teja Kumar',0.00),(68,4,'CSE23008','Charan Reddy',0.00),(69,4,'CSE23009','Pavan Kumar',0.00),(70,4,'CSE23010','Nikhil Sai',0.00),(71,4,'CSE23011','Arjun Varma',0.00),(72,4,'CSE23012','Manoj Kumar',0.00),(73,4,'CSE23013','Rohit Sharma',0.00),(74,4,'CSE23014','Abhishek Reddy',0.00),(75,4,'CSE23015','Karthik Sai',0.00),(76,4,'CSE23016','Naveen Kumar',0.00),(77,4,'CSE23017','Lokesh Reddy',0.00),(78,4,'CSE23018','Vijay Krishna',0.00),(79,4,'CSE23019','Ajay Kumar',0.00),(80,4,'CSE23020','Sandeep Varma',0.00);
/*!40000 ALTER TABLE `marks_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marks_edit_log`
--

DROP TABLE IF EXISTS `marks_edit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marks_edit_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `old_marks` decimal(5,2) DEFAULT NULL,
  `new_marks` decimal(5,2) DEFAULT NULL,
  `edited_by` varchar(50) DEFAULT NULL,
  `reason` text,
  `edited_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marks_edit_log`
--

LOCK TABLES `marks_edit_log` WRITE;
/*!40000 ALTER TABLE `marks_edit_log` DISABLE KEYS */;
INSERT INTO `marks_edit_log` VALUES (1,1,'CSE23004',1.00,10.00,'FAC002','Wrong entry\r\n','2026-08-01 18:32:46'),(2,2,'CSE23020',17.00,15.00,'FAC001','Wrong entry','2026-08-01 20:14:32'),(3,3,'CSE23001',0.00,10.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(4,3,'CSE23002',0.00,15.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(5,3,'CSE23003',0.00,14.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(6,3,'CSE23004',0.00,11.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(7,3,'CSE23005',0.00,12.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(8,3,'CSE23006',0.00,13.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(9,3,'CSE23007',0.00,14.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(10,3,'CSE23008',0.00,15.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(11,3,'CSE23009',0.00,10.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(12,3,'CSE23010',0.00,9.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(13,3,'CSE23011',0.00,8.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(14,3,'CSE23012',0.00,7.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(15,3,'CSE23013',0.00,6.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(16,3,'CSE23014',0.00,5.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(17,3,'CSE23015',0.00,4.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(18,3,'CSE23016',0.00,1.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(19,3,'CSE23017',0.00,2.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(20,3,'CSE23018',0.00,2.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(21,3,'CSE23019',0.00,12.00,'FAC001','Wrong entry','2026-08-01 20:15:24'),(22,3,'CSE23020',0.00,20.00,'FAC001','Wrong entry','2026-08-01 20:15:24');
/*!40000 ALTER TABLE `marks_edit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marks_session`
--

DROP TABLE IF EXISTS `marks_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marks_session` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `faculty_id` varchar(20) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `semester` int NOT NULL,
  `section` varchar(10) NOT NULL,
  `assessment_type` varchar(30) NOT NULL,
  `total_students` int NOT NULL,
  `highest_marks` decimal(5,2) DEFAULT NULL,
  `lowest_marks` decimal(5,2) DEFAULT NULL,
  `average_marks` decimal(5,2) DEFAULT NULL,
  `pass_percentage` decimal(5,2) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marks_session`
--

LOCK TABLES `marks_session` WRITE;
/*!40000 ALTER TABLE `marks_session` DISABLE KEYS */;
INSERT INTO `marks_session` VALUES (1,'FAC002','Database Management Systems','Computer Science Engineering',3,'A','Mid-1',20,20.00,5.00,14.50,85.00,'2026-08-01 18:32:20'),(2,'FAC001','Data Structures','Computer Science Engineering',3,'A','Mid-1',20,20.00,1.00,12.20,85.00,'2026-08-01 19:27:06'),(3,'FAC001','Data Structures','Computer Science Engineering',3,'A','Mid-2',20,20.00,1.00,9.50,65.00,'2026-08-01 19:46:49'),(4,'FAC002','Database Management Systems','Computer Science Engineering',3,'A','Mid-2',20,0.00,0.00,0.00,0.00,'2026-08-01 20:03:25');
/*!40000 ALTER TABLE `marks_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_otp`
--

DROP TABLE IF EXISTS `password_reset_otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_otp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `verified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_otp`
--

LOCK TABLES `password_reset_otp` WRITE;
/*!40000 ALTER TABLE `password_reset_otp` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_otp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sections` (
  `section_id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(10) NOT NULL,
  PRIMARY KEY (`section_id`),
  UNIQUE KEY `section_name` (`section_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
INSERT INTO `sections` VALUES (1,'A'),(2,'B'),(3,'C'),(4,'D');
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `semesters`
--

DROP TABLE IF EXISTS `semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `semesters` (
  `semester_id` int NOT NULL AUTO_INCREMENT,
  `semester_number` int NOT NULL,
  PRIMARY KEY (`semester_id`),
  UNIQUE KEY `semester_number` (`semester_number`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `semesters`
--

LOCK TABLES `semesters` WRITE;
/*!40000 ALTER TABLE `semesters` DISABLE KEYS */;
INSERT INTO `semesters` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8);
/*!40000 ALTER TABLE `semesters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email_id` varchar(60) DEFAULT NULL,
  `student_id` varchar(20) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `degree` varchar(30) DEFAULT NULL,
  `degree_period` varchar(20) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `father_mobile` varchar(15) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `mother_mobile` varchar(15) DEFAULT NULL,
  `parent_email` varchar(100) DEFAULT NULL,
  `semester` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `student_id` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (8,'CSE23001','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student001@college.edu','CSE23001','Rahul Kumar','9876500001','B.Tech','4 Years','Computer Science Engineering','A','Ramesh Kumar','9876600001','Sunitha Kumar','9876700001','parent001@gmail.com',3),(9,'CSE23002','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student002@college.edu','CSE23002','Sai Krishna','9876500002','B.Tech','4 Years','Computer Science Engineering','A','Krishna Rao','9876600002','Lakshmi Rao','9876700002','parent002@gmail.com',3),(10,'CSE23003','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student003@college.edu','CSE23003','Akhil Reddy','9876500003','B.Tech','4 Years','Computer Science Engineering','A','Suresh Reddy','9876600003','Padma Reddy','9876700003','parent003@gmail.com',3),(11,'CSE23004','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student004@college.edu','CSE23004','Kiran Kumar','9876500004','B.Tech','4 Years','Computer Science Engineering','A','Prasad Kumar','9876600004','Anitha Kumar','9876700004','parent004@gmail.com',3),(12,'CSE23005','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student005@college.edu','CSE23005','Harsha Vardhan','9876500005','B.Tech','4 Years','Computer Science Engineering','A','Ravi Kumar','9876600005','Jyothi Kumar','9876700005','parent005@gmail.com',3),(13,'CSE23006','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student006@college.edu','CSE23006','Vamsi Krishna','9876500006','B.Tech','4 Years','Computer Science Engineering','A','Nagesh Kumar','9876600006','Sarala Kumar','9876700006','parent006@gmail.com',3),(14,'CSE23007','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student007@college.edu','CSE23007','Teja Kumar','9876500007','B.Tech','4 Years','Computer Science Engineering','A','Raghava Kumar','9876600007','Sujatha Kumar','9876700007','parent007@gmail.com',3),(15,'CSE23008','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student008@college.edu','CSE23008','Charan Reddy','9876500008','B.Tech','4 Years','Computer Science Engineering','A','Reddy Prasad','9876600008','Bhavani Reddy','9876700008','parent008@gmail.com',3),(16,'CSE23009','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student009@college.edu','CSE23009','Pavan Kumar','9876500009','B.Tech','4 Years','Computer Science Engineering','A','Mohan Kumar','9876600009','Srilatha Kumar','9876700009','parent009@gmail.com',3),(17,'CSE23010','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student010@college.edu','CSE23010','Nikhil Sai','9876500010','B.Tech','4 Years','Computer Science Engineering','A','Ravi Teja','9876600010','Kavitha Teja','9876700010','parent010@gmail.com',3),(18,'CSE23011','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student011@college.edu','CSE23011','Arjun Varma','9876500011','B.Tech','4 Years','Computer Science Engineering','A','Raghav Varma','9876600011','Deepa Varma','9876700011','parent011@gmail.com',3),(19,'CSE23012','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student012@college.edu','CSE23012','Manoj Kumar','9876500012','B.Tech','4 Years','Computer Science Engineering','A','Prakash Kumar','9876600012','Shobha Kumar','9876700012','parent012@gmail.com',3),(20,'CSE23013','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student013@college.edu','CSE23013','Rohit Sharma','9876500013','B.Tech','4 Years','Computer Science Engineering','A','Mahesh Sharma','9876600013','Anjali Sharma','9876700013','parent013@gmail.com',3),(21,'CSE23014','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student014@college.edu','CSE23014','Abhishek Reddy','9876500014','B.Tech','4 Years','Computer Science Engineering','A','Naresh Reddy','9876600014','Swathi Reddy','9876700014','parent014@gmail.com',3),(22,'CSE23015','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student015@college.edu','CSE23015','Karthik Sai','9876500015','B.Tech','4 Years','Computer Science Engineering','A','Venkatesh','9876600015','Lalitha','9876700015','parent015@gmail.com',3),(23,'CSE23016','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student016@college.edu','CSE23016','Naveen Kumar','9876500016','B.Tech','4 Years','Computer Science Engineering','A','Ramesh Kumar','9876600016','Geetha Kumar','9876700016','parent016@gmail.com',3),(24,'CSE23017','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student017@college.edu','CSE23017','Lokesh Reddy','9876500017','B.Tech','4 Years','Computer Science Engineering','A','Srinivas Reddy','9876600017','Bhavya Reddy','9876700017','parent017@gmail.com',3),(25,'CSE23018','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student018@college.edu','CSE23018','Vijay Krishna','9876500018','B.Tech','4 Years','Computer Science Engineering','A','Ravi Krishna','9876600018','Sujatha Krishna','9876700018','parent018@gmail.com',3),(26,'CSE23019','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student019@college.edu','CSE23019','Ajay Kumar','9876500019','B.Tech','4 Years','Computer Science Engineering','A','Anand Kumar','9876600019','Kavitha Kumar','9876700019','parent019@gmail.com',3),(27,'CSE23020','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','student020@college.edu','CSE23020','Sandeep Varma','9876500020','B.Tech','4 Years','Computer Science Engineering','A','Ramesh Varma','9876600020','Padma Varma','9876700020','parent020@gmail.com',3),(28,'AI23021','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23021@college.edu','AI23021','Aditya Verma','9876500021','B.Tech','4 Years','Artificial Intelligence','B','Rakesh Verma','9876600021','Neelima Verma','9876700021','parent021@gmail.com',3),(29,'AI23022','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23022@college.edu','AI23022','Rohan Gupta','9876500022','B.Tech','4 Years','Artificial Intelligence','B','Sanjay Gupta','9876600022','Anita Gupta','9876700022','parent022@gmail.com',3),(30,'AI23023','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23023@college.edu','AI23023','Vivek Sharma','9876500023','B.Tech','4 Years','Artificial Intelligence','B','Rajesh Sharma','9876600023','Kiran Sharma','9876700023','parent023@gmail.com',3),(31,'AI23024','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23024@college.edu','AI23024','Karthik Reddy','9876500024','B.Tech','4 Years','Artificial Intelligence','B','Suresh Reddy','9876600024','Lakshmi Reddy','9876700024','parent024@gmail.com',3),(32,'AI23025','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23025@college.edu','AI23025','Arun Kumar','9876500025','B.Tech','4 Years','Artificial Intelligence','B','Prasad Kumar','9876600025','Jyothi Kumar','9876700025','parent025@gmail.com',3),(33,'AI23026','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23026@college.edu','AI23026','Naveen Sai','9876500026','B.Tech','4 Years','Artificial Intelligence','B','Venkatesh','9876600026','Saritha','9876700026','parent026@gmail.com',3),(34,'AI23027','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23027@college.edu','AI23027','Harish Kumar','9876500027','B.Tech','4 Years','Artificial Intelligence','B','Madhav Kumar','9876600027','Deepa Kumar','9876700027','parent027@gmail.com',3),(35,'AI23028','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23028@college.edu','AI23028','Lokesh Varma','9876500028','B.Tech','4 Years','Artificial Intelligence','B','Ravi Varma','9876600028','Bhavana Varma','9876700028','parent028@gmail.com',3),(36,'AI23029','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23029@college.edu','AI23029','Pavan Krishna','9876500029','B.Tech','4 Years','Artificial Intelligence','B','Krishna Murthy','9876600029','Swathi Krishna','9876700029','parent029@gmail.com',3),(37,'AI23030','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23030@college.edu','AI23030','Surya Teja','9876500030','B.Tech','4 Years','Artificial Intelligence','B','Ramesh Teja','9876600030','Kavitha Teja','9876700030','parent030@gmail.com',3),(38,'AI23031','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23031@college.edu','AI23031','Pranav Kumar','9876500031','B.Tech','4 Years','Artificial Intelligence','B','Raj Kumar','9876600031','Sunitha Kumar','9876700031','parent031@gmail.com',3),(39,'AI23032','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23032@college.edu','AI23032','Varun Reddy','9876500032','B.Tech','4 Years','Artificial Intelligence','B','Suresh Reddy','9876600032','Lakshmi Reddy','9876700032','parent032@gmail.com',3),(40,'AI23033','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23033@college.edu','AI23033','Aravind Sai','9876500033','B.Tech','4 Years','Artificial Intelligence','B','Ravi Sai','9876600033','Anitha Sai','9876700033','parent033@gmail.com',3),(41,'AI23034','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23034@college.edu','AI23034','Vishal Gupta','9876500034','B.Tech','4 Years','Artificial Intelligence','B','Anil Gupta','9876600034','Kavitha Gupta','9876700034','parent034@gmail.com',3),(42,'AI23035','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23035@college.edu','AI23035','Nithin Kumar','9876500035','B.Tech','4 Years','Artificial Intelligence','B','Mahesh Kumar','9876600035','Sujatha Kumar','9876700035','parent035@gmail.com',3),(43,'AI23036','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23036@college.edu','AI23036','Rohit Verma','9876500036','B.Tech','4 Years','Artificial Intelligence','B','Ajay Verma','9876600036','Deepa Verma','9876700036','parent036@gmail.com',3),(44,'AI23037','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23037@college.edu','AI23037','Harsha Kumar','9876500037','B.Tech','4 Years','Artificial Intelligence','B','Prasad Kumar','9876600037','Bhavani Kumar','9876700037','parent037@gmail.com',3),(45,'AI23038','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23038@college.edu','AI23038','Koushik Reddy','9876500038','B.Tech','4 Years','Artificial Intelligence','B','Nagesh Reddy','9876600038','Saritha Reddy','9876700038','parent038@gmail.com',3),(46,'AI23039','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23039@college.edu','AI23039','Sachin Kumar','9876500039','B.Tech','4 Years','Artificial Intelligence','B','Ramesh Kumar','9876600039','Padma Kumar','9876700039','parent039@gmail.com',3),(47,'AI23040','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ai23040@college.edu','AI23040','Yash Sharma','9876500040','B.Tech','4 Years','Artificial Intelligence','B','Sanjay Sharma','9876600040','Anjali Sharma','9876700040','parent040@gmail.com',3),(48,'ECE23041','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23041@college.edu','ECE23041','Arjun Reddy','9876500041','B.Tech','4 Years','Electronics and Communication Engineering','C','Ramesh Reddy','9876600041','Lakshmi Reddy','9876700041','parent041@gmail.com',3),(49,'ECE23042','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23042@college.edu','ECE23042','Sai Charan','9876500042','B.Tech','4 Years','Electronics and Communication Engineering','C','Mohan Rao','9876600042','Sujatha Rao','9876700042','parent042@gmail.com',3),(50,'ECE23043','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23043@college.edu','ECE23043','Naveen Kumar','9876500043','B.Tech','4 Years','Electronics and Communication Engineering','C','Ravi Kumar','9876600043','Anitha Kumar','9876700043','parent043@gmail.com',3),(51,'ECE23044','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23044@college.edu','ECE23044','Harish Varma','9876500044','B.Tech','4 Years','Electronics and Communication Engineering','C','Srinivas Varma','9876600044','Padma Varma','9876700044','parent044@gmail.com',3),(52,'ECE23045','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23045@college.edu','ECE23045','Rohit Sai','9876500045','B.Tech','4 Years','Electronics and Communication Engineering','C','Prasad Sai','9876600045','Bhavani Sai','9876700045','parent045@gmail.com',3),(53,'ECE23046','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23046@college.edu','ECE23046','Vijay Krishna','9876500046','B.Tech','4 Years','Electronics and Communication Engineering','C','Raghava Krishna','9876600046','Deepa Krishna','9876700046','parent046@gmail.com',3),(54,'ECE23047','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23047@college.edu','ECE23047','Ajay Kumar','9876500047','B.Tech','4 Years','Electronics and Communication Engineering','C','Raj Kumar','9876600047','Shobha Kumar','9876700047','parent047@gmail.com',3),(55,'ECE23048','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23048@college.edu','ECE23048','Lokesh Sharma','9876500048','B.Tech','4 Years','Electronics and Communication Engineering','C','Mahesh Sharma','9876600048','Anjali Sharma','9876700048','parent048@gmail.com',3),(56,'ECE23049','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23049@college.edu','ECE23049','Kiran Teja','9876500049','B.Tech','4 Years','Electronics and Communication Engineering','C','Suresh Teja','9876600049','Saritha Teja','9876700049','parent049@gmail.com',3),(57,'ECE23050','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23050@college.edu','ECE23050','Abhishek Reddy','9876500050','B.Tech','4 Years','Electronics and Communication Engineering','C','Naresh Reddy','9876600050','Jyothi Reddy','9876700050','parent050@gmail.com',3),(58,'ECE23051','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23051@student.college.edu','ECE23051','Aditya Kumar','9876500051','B.Tech','4 Years','Electronics and Communication Engineering','C','Ravi Kumar','9876600051','Sujatha Kumar','9876700051','parent051@gmail.com',3),(59,'ECE23052','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23052@student.college.edu','ECE23052','Nikhil Reddy','9876500052','B.Tech','4 Years','Electronics and Communication Engineering','C','Suresh Reddy','9876600052','Lakshmi Reddy','9876700052','parent052@gmail.com',3),(60,'ECE23053','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23053@student.college.edu','ECE23053','Karthik Varma','9876500053','B.Tech','4 Years','Electronics and Communication Engineering','C','Ramesh Varma','9876600053','Padma Varma','9876700053','parent053@gmail.com',3),(61,'ECE23054','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23054@student.college.edu','ECE23054','Sai Praneeth','9876500054','B.Tech','4 Years','Electronics and Communication Engineering','C','Mohan Rao','9876600054','Bhavani Rao','9876700054','parent054@gmail.com',3),(62,'ECE23055','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23055@student.college.edu','ECE23055','Harsha Kumar','9876500055','B.Tech','4 Years','Electronics and Communication Engineering','C','Prasad Kumar','9876600055','Anitha Kumar','9876700055','parent055@gmail.com',3),(63,'ECE23056','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23056@student.college.edu','ECE23056','Vamsi Krishna','9876500056','B.Tech','4 Years','Electronics and Communication Engineering','C','Raghava Krishna','9876600056','Deepa Krishna','9876700056','parent056@gmail.com',3),(64,'ECE23057','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23057@student.college.edu','ECE23057','Lokesh Sai','9876500057','B.Tech','4 Years','Electronics and Communication Engineering','C','Nagesh Sai','9876600057','Saritha Sai','9876700057','parent057@gmail.com',3),(65,'ECE23058','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23058@student.college.edu','ECE23058','Rohit Sharma','9876500058','B.Tech','4 Years','Electronics and Communication Engineering','C','Rajesh Sharma','9876600058','Anjali Sharma','9876700058','parent058@gmail.com',3),(66,'ECE23059','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23059@student.college.edu','ECE23059','Pranav Gupta','9876500059','B.Tech','4 Years','Electronics and Communication Engineering','C','Sanjay Gupta','9876600059','Kiran Gupta','9876700059','parent059@gmail.com',3),(67,'ECE23060','b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54','ece23060@student.college.edu','ECE23060','Yash Verma','9876500060','B.Tech','4 Years','Electronics and Communication Engineering','C','Ajay Verma','9876600060','Neelima Verma','9876700060','parent060@gmail.com',3);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `subject_id` int NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `department_name` varchar(100) DEFAULT NULL,
  `semester` int DEFAULT NULL,
  `credits` int DEFAULT NULL,
  PRIMARY KEY (`subject_id`),
  UNIQUE KEY `subject_code` (`subject_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,'CS301','Data Structures','Computer Science Engineering',3,4),(2,'CS302','Database Management Systems','Computer Science Engineering',3,4),(3,'CS303','Operating Systems','Computer Science Engineering',3,4),(4,'CS304','Computer Networks','Computer Science Engineering',3,3),(5,'CS305','Java Programming','Computer Science Engineering',3,3),(6,'CS306','Design and Analysis of Algorithms','Computer Science Engineering',3,4),(7,'CS307','Software Engineering','Computer Science Engineering',3,3),(8,'CS308','Artificial Intelligence','Computer Science Engineering',5,4);
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timetable`
--

DROP TABLE IF EXISTS `timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timetable` (
  `id` int NOT NULL AUTO_INCREMENT,
  `semester` int DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `academic_year` varchar(20) DEFAULT '2026-27',
  `day_name` varchar(20) DEFAULT NULL,
  `period1_time` varchar(20) DEFAULT '09:00-09:50',
  `period2_time` varchar(20) DEFAULT '09:50-10:40',
  `break_time` varchar(20) DEFAULT '10:40-11:00',
  `period3_time` varchar(20) DEFAULT '11:00-11:50',
  `period4_time` varchar(20) DEFAULT '11:50-12:40',
  `lunch_time` varchar(20) DEFAULT '12:40-01:30',
  `period5_time` varchar(20) DEFAULT '01:30-02:20',
  `period6_time` varchar(20) DEFAULT '02:20-03:10',
  `period1` varchar(100) DEFAULT NULL,
  `period2` varchar(100) DEFAULT NULL,
  `period3` varchar(100) DEFAULT NULL,
  `period4` varchar(100) DEFAULT NULL,
  `period5` varchar(100) DEFAULT NULL,
  `period6` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable`
--

LOCK TABLES `timetable` WRITE;
/*!40000 ALTER TABLE `timetable` DISABLE KEYS */;
INSERT INTO `timetable` VALUES (1,3,'A','2026-27','Monday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Data Structures','Database Management Systems','Operating Systems','Java Programming','Computer Networks','Design and Analysis of Algorithms'),(2,3,'A','2026-27','Tuesday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Database Management Systems','Operating Systems','Data Structures','Computer Networks','Java Programming','Design and Analysis of Algorithms'),(3,3,'A','2026-27','Wednesday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Operating Systems','Data Structures','Database Management Systems','Design and Analysis of Algorithms','Computer Networks','Java Programming'),(4,3,'A','2026-27','Thursday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Java Programming','Computer Networks','Operating Systems','Data Structures','Database Management Systems','Design and Analysis of Algorithms'),(5,3,'A','2026-27','Friday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Computer Networks','Java Programming','Data Structures','Operating Systems','Database Management Systems','Design and Analysis of Algorithms'),(6,3,'A','2026-27','Saturday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Design and Analysis of Algorithms','Data Structures','Java Programming','Database Management Systems','Operating Systems','Computer Networks'),(7,3,'B','2026-27','Monday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Artificial Intelligence','Data Structures','Database Management Systems','Operating Systems','Java Programming','Computer Networks'),(8,3,'B','2026-27','Tuesday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Database Management Systems','Artificial Intelligence','Operating Systems','Computer Networks','Data Structures','Java Programming'),(9,3,'B','2026-27','Wednesday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Operating Systems','Java Programming','Artificial Intelligence','Database Management Systems','Computer Networks','Data Structures'),(10,3,'B','2026-27','Thursday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Computer Networks','Operating Systems','Data Structures','Artificial Intelligence','Java Programming','Database Management Systems'),(11,3,'B','2026-27','Friday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Java Programming','Database Management Systems','Artificial Intelligence','Computer Networks','Operating Systems','Data Structures'),(12,3,'B','2026-27','Saturday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Artificial Intelligence','Computer Networks','Java Programming','Data Structures','Database Management Systems','Operating Systems'),(13,3,'C','2026-27','Monday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Digital Electronics','Signals and Systems','Engineering Mathematics','Electronic Devices','Network Theory','Communication Systems'),(14,3,'C','2026-27','Tuesday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Signals and Systems','Digital Electronics','Electronic Devices','Communication Systems','Engineering Mathematics','Network Theory'),(15,3,'C','2026-27','Wednesday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Electronic Devices','Engineering Mathematics','Digital Electronics','Signals and Systems','Communication Systems','Network Theory'),(16,3,'C','2026-27','Thursday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Communication Systems','Network Theory','Signals and Systems','Digital Electronics','Electronic Devices','Engineering Mathematics'),(17,3,'C','2026-27','Friday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Engineering Mathematics','Digital Electronics','Communication Systems','Network Theory','Signals and Systems','Electronic Devices'),(18,3,'C','2026-27','Saturday','09:00-09:50','09:50-10:40','10:40-11:00','11:00-11:50','11:50-12:40','12:40-01:30','01:30-02:20','02:20-03:10','Network Theory','Communication Systems','Engineering Mathematics','Electronic Devices','Digital Electronics','Signals and Systems');
/*!40000 ALTER TABLE `timetable` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-02  2:23:51
