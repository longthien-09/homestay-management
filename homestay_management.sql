CREATE DATABASE  IF NOT EXISTS `homestay_management` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `homestay_management`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: homestay_management
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `booking_services`
--

DROP TABLE IF EXISTS `booking_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_services` (
  `booking_id` int NOT NULL,
  `service_id` int NOT NULL,
  PRIMARY KEY (`booking_id`,`service_id`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `booking_services_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `booking_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_services`
--

LOCK TABLES `booking_services` WRITE;
/*!40000 ALTER TABLE `booking_services` DISABLE KEYS */;
INSERT INTO `booking_services` VALUES (25,28),(26,28),(28,28),(29,28),(31,28),(33,28),(69,28),(72,28),(54,33),(72,33),(53,35),(54,35);
/*!40000 ALTER TABLE `booking_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `status` enum('PENDING','CONFIRMED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (25,19,16,'2025-08-28','2025-08-29','PENDING','2025-08-28 16:53:21'),(26,19,17,'2025-08-31','2025-09-01','PENDING','2025-08-28 18:43:27'),(27,19,16,'2025-09-06','2025-09-07','CONFIRMED','2025-08-28 19:07:09'),(28,19,17,'2025-09-07','2025-09-08','PENDING','2025-08-28 19:21:39'),(29,19,18,'2025-08-28','2025-08-29','PENDING','2025-08-28 19:25:14'),(30,19,19,'2025-08-28','2025-08-29','PENDING','2025-08-28 19:28:01'),(31,19,18,'2025-09-03','2025-09-04','PENDING','2025-08-28 19:34:37'),(32,19,18,'2025-10-03','2025-10-04','PENDING','2025-08-28 19:38:13'),(33,19,19,'2025-08-30','2025-08-31','CANCELLED','2025-08-28 19:44:12'),(34,19,17,'2025-08-29','2025-08-30','PENDING','2025-08-29 01:56:09'),(35,19,16,'2025-09-03','2025-09-04','PENDING','2025-09-03 04:43:36'),(36,19,16,'2025-09-04','2025-09-05','CONFIRMED','2025-09-03 08:05:07'),(37,19,17,'2025-09-03','2025-09-04','PENDING','2025-09-03 08:16:59'),(38,19,19,'2025-09-24','2025-09-27','PENDING','2025-09-03 09:35:25'),(39,19,17,'2025-09-04','2025-09-05','PENDING','2025-09-03 17:24:38'),(40,19,19,'2025-09-04','2025-09-05','PENDING','2025-09-03 17:28:50'),(41,19,18,'2025-09-04','2025-09-05','CONFIRMED','2025-09-03 17:32:57'),(42,19,18,'2025-09-18','2025-09-19','PENDING','2025-09-03 17:37:08'),(43,19,17,'2025-09-22','2025-09-23','PENDING','2025-09-03 17:43:22'),(44,19,18,'2025-09-19','2025-09-20','PENDING','2025-09-04 04:10:47'),(45,19,17,'2025-09-19','2025-09-20','PENDING','2025-09-04 04:13:42'),(46,19,16,'2025-09-19','2025-09-20','PENDING','2025-09-04 04:16:23'),(47,19,19,'2025-09-20','2025-09-21','PENDING','2025-09-04 04:23:03'),(48,19,19,'2025-09-19','2025-09-20','PENDING','2025-09-04 04:28:19'),(49,19,19,'2025-09-12','2025-09-13','PENDING','2025-09-04 04:30:53'),(50,19,19,'2025-09-23','2025-09-24','PENDING','2025-09-04 04:34:23'),(51,19,19,'2025-09-15','2025-09-16','PENDING','2025-09-04 04:39:19'),(52,19,17,'2025-09-05','2025-09-06','PENDING','2025-09-04 04:41:05'),(53,19,16,'2025-09-22','2025-09-23','PENDING','2025-09-04 04:42:32'),(54,19,17,'2025-09-23','2025-09-24','PENDING','2025-09-04 04:53:31'),(55,19,20,'2025-09-04','2025-09-05','CONFIRMED','2025-09-04 09:10:50'),(56,19,17,'2025-09-25','2025-09-26','PENDING','2025-09-04 14:23:15'),(57,19,20,'2025-09-23','2025-09-24','PENDING','2025-09-04 14:27:14'),(58,19,20,'2025-09-25','2025-09-26','PENDING','2025-09-05 02:23:27'),(59,19,16,'2025-09-13','2025-09-14','PENDING','2025-09-05 02:42:20'),(60,19,18,'2025-09-26','2025-09-27','CONFIRMED','2025-09-05 02:48:39'),(61,19,20,'2025-09-30','2025-10-01','CONFIRMED','2025-09-05 02:49:18'),(62,19,18,'2025-09-05','2025-09-09','CONFIRMED','2025-09-05 04:32:15'),(63,19,19,'2025-09-05','2025-09-06','PENDING','2025-09-05 07:42:02'),(64,19,18,'2025-10-01','2025-10-02','PENDING','2025-09-05 08:06:10'),(65,19,17,'2025-10-01','2025-10-02','PENDING','2025-09-05 08:08:44'),(66,22,20,'2025-09-05','2025-09-06','PENDING','2025-09-05 08:10:42'),(67,19,17,'2025-09-06','2025-09-07','PENDING','2025-09-05 08:15:13'),(68,19,19,'2025-09-06','2025-09-07','PENDING','2025-09-05 08:15:33'),(69,19,16,'2025-09-24','2025-10-04','PENDING','2025-09-06 01:34:48'),(70,19,20,'2025-09-06','2025-09-07','PENDING','2025-09-06 04:47:01'),(71,19,20,'2025-09-26','2025-09-27','PENDING','2025-09-06 04:47:33'),(72,19,17,'2025-09-20','2025-09-21','PENDING','2025-09-06 04:49:54');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Ăn uống'),(11,'Bữa ăn'),(3,'Di chuyển'),(5,'Dịch vụ bổ sung'),(2,'Giải trí'),(12,'Sở thích giường'),(13,'Tiện ích bất động sản'),(4,'Tiện ích phòng');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homestay_images`
--

DROP TABLE IF EXISTS `homestay_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homestay_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `homestay_id` int NOT NULL,
  `file_path` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_homestay_images_homestay` (`homestay_id`),
  CONSTRAINT `fk_homestay_images_homestay` FOREIGN KEY (`homestay_id`) REFERENCES `homestays` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homestay_images`
--

LOCK TABLES `homestay_images` WRITE;
/*!40000 ALTER TABLE `homestay_images` DISABLE KEYS */;
INSERT INTO `homestay_images` VALUES (1,43,'uploads/homestays/43/1756972062523_doi.jpg',1),(2,43,'uploads/homestays/43/1756972094063_tải xuống.jpg',2),(3,43,'uploads/homestays/43/7409124e-7302-4584-b358-43e9e8e854a2_1d6d2eec-2.-banner-tintucapp-1920x1080-1.jpg',3),(4,43,'uploads/homestays/43/6c223e42-61ba-4ae3-9864-0a32de2d7b2c_350x495_4_.jpg',4),(5,43,'uploads/homestays/43/6d8091fe-4ded-45bd-ba70-4888231ae91b_284550373-370852648356152-3746905122681766979-n-3012.jpg',5),(6,43,'uploads/homestays/43/a2c2c13d-d9c3-4899-a235-16aca907aa12_1454575960-1454574839-201602041115775285_56b2b5bbe22fe_99_20160204112309.jpg',6),(7,43,'uploads/homestays/43/adad102d-2b83-45fd-96ad-4dcec1edcda2_avatar-3-featured.avif',7),(8,43,'uploads/homestays/43/f5ec8659-c96a-4f30-afb2-803c2f1889a7_d4bab0d4-b0b8-42e5-a0eb-35c98ec63dc9.jpeg',8),(9,43,'uploads/homestays/43/35203da7-36de-456a-8852-122015388c1e_doi.jpg',9),(10,43,'uploads/homestays/43/7e06d8b7-5114-4607-8ce0-632491416eab_1d6d2eec-2.-banner-tintucapp-1920x1080-1.jpg',10),(11,43,'uploads/homestays/43/2ec9cd26-3f01-443a-b4c3-80b1c6fa266a_350x495_4_.jpg',11),(12,43,'uploads/homestays/43/c5c50ed4-7d96-43e7-ba49-73ceda9661d9_284550373-370852648356152-3746905122681766979-n-3012.jpg',12),(13,43,'uploads/homestays/43/44eb2111-dca5-4aea-9787-59d502167b25_1454575960-1454574839-201602041115775285_56b2b5bbe22fe_99_20160204112309.jpg',13),(14,43,'uploads/homestays/43/64803615-9d1f-4dbd-9192-b1e12f461add_avengers-endgame-15560172149681593480735.webp',14),(15,43,'uploads/homestays/43/06a9fd19-6ffe-40f0-b1d6-8430e1772894_cadl1.png',15),(16,43,'uploads/homestays/43/8ad88177-a417-45bd-9ad8-72d36e66b2d1_csdl.png',16),(17,43,'uploads/homestays/43/cb2c7048-2cb2-44a5-ade5-2c3c0a11f142_d4bab0d4-b0b8-42e5-a0eb-35c98ec63dc9.jpeg',17),(18,43,'uploads/homestays/43/c12b8346-40f5-438b-803b-d0e956b0b675_doi.jpg',18),(19,43,'uploads/homestays/43/aeaf00e8-0c90-481e-aba1-c12c99eb0e14_Mango.jpg',19),(20,43,'uploads/homestays/43/bb04543e-b3c8-4e04-97ed-2d44ce6a4046_maxresdefault.jpg',20),(21,43,'uploads/homestays/43/cbbef2e4-c2e7-4352-9bab-2321c8d84757_MV5BZTAzMTkyNmQtNTMzZS00MTM1LWI4YzEtMjVlYjU0ZWI5Y2IzXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg',21),(22,43,'uploads/homestays/43/5b758067-f9cb-4a8f-ade8-54c6d895e7d1_phong1.jpg',22),(23,43,'uploads/homestays/43/f0ac0c05-7d67-48a8-be75-d3319da605dd_phong3.jpg',23),(24,43,'uploads/homestays/43/8e254b77-fecb-4a77-b38a-310cd03463f9_phong4.jpg',24),(25,48,'uploads/homestays/48/045f7ff0-5bf9-4cb9-be8d-36ea4563cb8f_Screenshot (1).png',1),(26,48,'uploads/homestays/48/b39c84a8-4736-4b48-a3f6-460b363e20ed_Screenshot (2).png',2),(27,48,'uploads/homestays/48/91f970bd-82f8-441d-8d3d-3f7395d54a8f_Screenshot (3).png',3),(28,48,'uploads/homestays/48/37d18907-d8c7-41e7-bc48-5fc0dc38f71e_Screenshot (4).png',4),(29,48,'uploads/homestays/48/ee40cc83-8a88-43c7-a35d-bb2238d5a24c_Screenshot (5).png',5),(30,48,'uploads/homestays/48/7b87d72c-7325-4e05-af04-65657e7afcb3_Screenshot (6).png',6),(31,48,'uploads/homestays/48/da69b01a-8d6b-4dfb-bccc-7010ce56a6cf_Screenshot (7).png',7),(32,48,'uploads/homestays/48/c48f0ec8-2700-4e2f-abbe-3af9a2581d3f_Screenshot (8).png',8),(33,48,'uploads/homestays/48/b91c0c68-fe85-4e4f-8bba-5babc01d1003_Screenshot (9).png',9),(34,48,'uploads/homestays/48/d1675bbf-c9ee-40b6-93f9-b0d37cbca0eb_Screenshot (10).png',10);
/*!40000 ALTER TABLE `homestay_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homestays`
--

DROP TABLE IF EXISTS `homestays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homestays` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` mediumtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homestays`
--

LOCK TABLES `homestays` WRITE;
/*!40000 ALTER TABLE `homestays` DISABLE KEYS */;
INSERT INTO `homestays` VALUES (43,'The Kupid Hill Homestay','Đà Lạt','0234567891','Kupid@gmail.com','/homestay-management/uploads/1757121620899_homestay.jpg','View đồi thông lãng mạn, không gian yên tĩnh, phù hợp cặp đôi.'),(44,'Mango Homestay','Hội An','0296543147','Mango@gmail.com','/homestay-management/uploads/1757121632251_phong4.jpg','Không gian xanh, yên bình, có vườn cây ăn trái.'),(45,'The Chi Novelty Homestay','TP.HCM','0234567891','Novelty@gmail.com','/homestay-management/uploads/1756399050866_homestay.jpg','Thiết kế hiện đại, tiện nghi, gần trung tâm thành phố.'),(46,'The Chi Novelty Homestay','TP.HCM','0234567891','Novelty@gmail.com','/homestay-management/uploads/1757121690170_phong4.jpg','123123'),(48,'Homestay TLS','10 Nguyễn Huệ','012345899','TLS@gmail.com','/homestay-management/uploads/1757123383532_Screenshot (1).png','Đẹp');
/*!40000 ALTER TABLE `homestays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manager_homestays`
--

DROP TABLE IF EXISTS `manager_homestays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manager_homestays` (
  `user_id` int NOT NULL,
  `homestay_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`homestay_id`),
  KEY `homestay_id` (`homestay_id`),
  CONSTRAINT `manager_homestays_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `manager_homestays_ibfk_2` FOREIGN KEY (`homestay_id`) REFERENCES `homestays` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manager_homestays`
--

LOCK TABLES `manager_homestays` WRITE;
/*!40000 ALTER TABLE `manager_homestays` DISABLE KEYS */;
INSERT INTO `manager_homestays` VALUES (20,43),(20,44),(21,45),(20,46),(23,48);
/*!40000 ALTER TABLE `manager_homestays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `method` enum('CASH','CREDIT_CARD','BANK_TRANSFER') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('UNPAID','PENDING','PAID') COLLATE utf8mb4_unicode_ci DEFAULT 'UNPAID',
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (45,25,30000.00,'2025-08-28 18:38:35','CASH','PENDING'),(46,25,150000.00,'2025-08-28 18:38:55','CASH','PAID'),(47,25,150000.00,'2025-08-28 18:39:01','BANK_TRANSFER','PAID'),(48,25,150000.00,'2025-08-28 18:39:44','BANK_TRANSFER','PENDING'),(49,26,2500000.00,'2025-08-28 18:43:27','CASH','PENDING'),(50,26,180000.00,'2025-08-28 18:52:13','CASH','PENDING'),(52,28,2500000.00,'2025-08-28 19:21:39','BANK_TRANSFER','PENDING'),(53,29,1000000.00,'2025-08-28 19:25:14','CASH','PENDING'),(54,30,1000000.00,'2025-08-28 19:28:01','CASH','PENDING'),(55,31,1000000.00,'2025-08-28 19:34:37','CASH','PENDING'),(56,32,1000000.00,'2025-08-28 19:38:13','CASH','PENDING'),(57,33,1000000.00,'2025-08-28 19:44:12','CASH','PENDING'),(59,34,2500000.00,'2025-08-29 01:56:09','BANK_TRANSFER','PAID'),(60,35,1500000.00,'2025-09-03 04:43:36',NULL,'UNPAID'),(61,36,1500000.00,'2025-09-03 08:05:07',NULL,'UNPAID'),(62,37,2500000.00,'2025-09-03 08:17:00',NULL,'UNPAID'),(63,38,1000000.00,'2025-09-03 09:35:25',NULL,'UNPAID'),(64,39,2500000.00,'2025-09-03 17:24:38',NULL,'UNPAID'),(65,40,1000000.00,'2025-09-03 17:28:50',NULL,'UNPAID'),(66,41,1000000.00,'2025-09-03 17:32:57',NULL,'UNPAID'),(67,42,1000000.00,'2025-09-03 17:37:08',NULL,'UNPAID'),(68,43,2500000.00,'2025-09-03 17:43:22',NULL,'UNPAID'),(69,44,1000000.00,'2025-09-04 04:10:47','CASH','PAID'),(70,45,2500000.00,'2025-09-04 04:13:42',NULL,'UNPAID'),(71,46,1500000.00,'2025-09-04 04:16:23','BANK_TRANSFER','PAID'),(72,47,1000000.00,'2025-09-04 04:23:03',NULL,'UNPAID'),(73,48,1000000.00,'2025-09-04 04:28:19',NULL,'UNPAID'),(74,49,1000000.00,'2025-09-04 04:30:53',NULL,'UNPAID'),(75,50,1000000.00,'2025-09-04 04:34:23',NULL,'UNPAID'),(76,51,1000000.00,'2025-09-04 04:39:19',NULL,'UNPAID'),(77,52,2650000.00,'2025-09-04 04:41:05','CASH','PAID'),(78,53,1900000.00,'2025-09-04 04:42:32','BANK_TRANSFER','PAID'),(79,54,3100000.00,'2025-09-04 04:53:31','BANK_TRANSFER','PAID'),(80,55,2500000.00,'2025-09-04 09:10:50',NULL,'UNPAID'),(81,56,2500000.00,'2025-09-04 14:23:16',NULL,'UNPAID'),(82,57,2500000.00,'2025-09-04 14:27:14',NULL,'UNPAID'),(83,58,2500000.00,'2025-09-05 02:23:28',NULL,'UNPAID'),(84,59,1500000.00,'2025-09-05 02:42:20',NULL,'UNPAID'),(85,60,1000000.00,'2025-09-05 02:48:39','CASH','PENDING'),(86,61,2500000.00,'2025-09-05 02:49:18','BANK_TRANSFER','PAID'),(87,62,4000000.00,'2025-09-05 04:32:15','BANK_TRANSFER','PAID'),(88,63,1000000.00,'2025-09-05 07:42:02','CASH','PAID'),(89,64,1000000.00,'2025-09-05 08:06:10',NULL,'UNPAID'),(90,65,2500000.00,'2025-09-05 08:08:44','CASH','PAID'),(91,66,2500000.00,'2025-09-05 08:10:42',NULL,'UNPAID'),(92,67,2500000.00,'2025-09-05 08:15:13',NULL,'UNPAID'),(93,68,1000000.00,'2025-09-05 08:15:33',NULL,'UNPAID'),(94,69,15000000.00,'2025-09-06 01:34:49','BANK_TRANSFER','PAID'),(95,70,2500000.00,'2025-09-06 04:47:01',NULL,'UNPAID'),(96,71,2500000.00,'2025-09-06 04:47:33',NULL,'UNPAID'),(97,72,2730000.00,'2025-09-06 04:49:54',NULL,'UNPAID');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` enum('AVAILABLE','BOOKED','MAINTENANCE') COLLATE utf8mb4_unicode_ci DEFAULT 'AVAILABLE',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` mediumtext COLLATE utf8mb4_unicode_ci,
  `homestay_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `homestay_id` (`homestay_id`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`homestay_id`) REFERENCES `homestays` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (16,'101','Đôi',1500000.00,'BOOKED',NULL,'Phù hợp cặp đôi, có ban công hoặc cửa sổ.',43),(17,'102','VIP',2500000.00,'AVAILABLE','/homestay-management/uploads/1756398074295_phong1.jpg','Phù hợp nghỉ dưỡng, không gian yên tĩnh.',43),(18,'103','Thường',1000000.00,'AVAILABLE','/homestay-management/uploads/1756398169182_phong3.jpg','Phù hợp khách lưu trú dài ngày.',43),(19,'104','Đôi',1000000.00,'AVAILABLE','/homestay-management/uploads/1756398519500_phong4.jpg','Giá rẻ, có tủ đồ cá nhân, phù hợp phượt thủ.',43),(20,'109','Đôi',2500000.00,'AVAILABLE','/homestay-management/uploads/1756975805315_d4bab0d4-b0b8-42e5-a0eb-35c98ec63dc9.jpeg','d',43);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(12,0) NOT NULL DEFAULT '0',
  `description` mediumtext COLLATE utf8mb4_unicode_ci,
  `homestay_id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `homestay_id` (`homestay_id`),
  KEY `idx_services_category` (`category_id`),
  CONSTRAINT `fk_services_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`homestay_id`) REFERENCES `homestays` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (28,'Giặt ',30000,'Dịch vụ giặt giá rẻ\r\n',43,NULL),(33,'Đưa đón sân bay',200000,'Xe 4 chỗ',43,3),(34,'Wi‑Fi',0,'Wi‑Fi miễn phí toàn bộ',43,4),(35,'Spa',300000,'Gói spa 60 phút',43,2),(36,'Bữa sáng',90000,'Set Việt',44,NULL),(37,'Thuê xe máy',150000,'Xe tay ga',44,3),(38,'Hồ bơi',0,'Hồ bơi ngoài trời',44,2),(39,'Tiện nghi nhà bếp',0,NULL,46,11),(40,'Tiện nghi nhà bếp',0,NULL,45,11),(41,'Tiện nghi nhà bếp',0,NULL,44,11),(42,'Tiện nghi nhà bếp',0,NULL,43,11),(43,'Bao gồm bữa sáng',0,NULL,46,11),(44,'Bao gồm bữa sáng',0,NULL,45,11),(45,'Bao gồm bữa sáng',0,NULL,44,11),(46,'Bao gồm bữa sáng',0,NULL,43,11),(47,'All-inclusive',0,NULL,46,11),(48,'All-inclusive',0,NULL,45,11),(49,'All-inclusive',0,NULL,44,11),(50,'All-inclusive',0,NULL,43,11),(51,'Bao gồm bữa sáng và bữa trưa',0,NULL,46,11),(52,'Bao gồm bữa sáng và bữa trưa',0,NULL,45,11),(53,'Bao gồm bữa sáng và bữa trưa',0,NULL,44,11),(54,'Bao gồm bữa sáng và bữa trưa',0,NULL,43,11),(55,'Bao gồm bữa sáng và bữa tối',0,NULL,46,11),(56,'Bao gồm bữa sáng và bữa tối',0,NULL,45,11),(57,'Bao gồm bữa sáng và bữa tối',0,NULL,44,11),(58,'Bao gồm bữa sáng và bữa tối',0,NULL,43,11),(59,'Giường đôi',0,NULL,46,12),(60,'Giường đôi',0,NULL,45,12),(61,'Giường đôi',0,NULL,44,12),(63,'Giường đơn',0,NULL,46,12),(64,'Giường đơn',0,NULL,45,12),(65,'Giường đơn',0,NULL,44,12),(67,'Bãi đậu xe',0,NULL,46,13),(68,'Bãi đậu xe',0,NULL,45,13),(69,'Bãi đậu xe',0,NULL,44,13),(71,'Wifi miễn phí',0,NULL,46,13),(72,'Wifi miễn phí',0,NULL,45,13),(73,'Wifi miễn phí',0,NULL,44,13),(74,'Wifi miễn phí',0,NULL,43,13),(75,'Phòng gia đình',0,NULL,46,13),(76,'Phòng gia đình',0,NULL,45,13),(77,'Phòng gia đình',0,NULL,44,13),(78,'Phòng gia đình',0,NULL,43,13),(79,'Phòng không hút thuốc',0,NULL,46,13),(80,'Phòng không hút thuốc',0,NULL,45,13),(81,'Phòng không hút thuốc',0,NULL,44,13),(82,'Phòng không hút thuốc',0,NULL,43,13),(83,'Quầy lễ tân 24 giờ',0,NULL,46,13),(84,'Quầy lễ tân 24 giờ',0,NULL,45,13),(85,'Quầy lễ tân 24 giờ',0,NULL,44,13),(86,'Quầy lễ tân 24 giờ',0,NULL,43,13),(87,'Xe đưa đón sân bay',0,NULL,46,13),(88,'Xe đưa đón sân bay',0,NULL,45,13),(89,'Xe đưa đón sân bay',0,NULL,44,13),(91,'Dịch vụ phòng',0,NULL,46,13),(92,'Dịch vụ phòng',0,NULL,45,13),(93,'Dịch vụ phòng',0,NULL,44,13),(94,'Dịch vụ phòng',0,NULL,43,13),(95,'Bể bơi',0,NULL,46,13),(96,'Bể bơi',0,NULL,45,13),(97,'Bể bơi',0,NULL,44,13),(98,'Bể bơi',0,NULL,43,13),(99,'Tiệm ăn',0,NULL,46,13),(100,'Tiệm ăn',0,NULL,45,13),(101,'Tiệm ăn',0,NULL,44,13),(102,'Tiệm ăn',0,NULL,43,13),(103,'Spa',0,NULL,46,13),(104,'Spa',0,NULL,45,13),(105,'Spa',0,NULL,44,13),(106,'Dành cho xe lăn',0,NULL,46,13),(107,'Dành cho xe lăn',0,NULL,45,13),(108,'Dành cho xe lăn',0,NULL,44,13),(109,'Dành cho xe lăn',0,NULL,43,13),(110,'Trung tâm thể dục',0,NULL,46,13),(111,'Trung tâm thể dục',0,NULL,45,13),(112,'Trung tâm thể dục',0,NULL,44,13),(113,'Trung tâm thể dục',0,NULL,43,13),(114,'Bồn tắm nước nóng/bể sục',0,NULL,46,13),(115,'Bồn tắm nước nóng/bể sục',0,NULL,45,13),(116,'Bồn tắm nước nóng/bể sục',0,NULL,44,13),(117,'Bồn tắm nước nóng/bể sục',0,NULL,43,13),(166,'Bữa sáng',60000,'Set Việt',46,NULL),(169,'Giường đơn',0,NULL,43,NULL),(171,'Xe đưa đón sân bay',0,NULL,43,NULL),(174,'Thuê xe máy',150000,'Xe tay ga',43,NULL),(184,'Bữa sáng',60000,'Set Việt',43,NULL),(194,'Giường đôi',0,NULL,43,NULL);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('ADMIN','MANAGER','USER') COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (19,'thien','1','Long Thiên','thien@gmail.com','9355784124','USER',1),(20,'Manager','1','Manager','Manager@gmail.com','0123456788','MANAGER',1),(21,'Manager1','1','Manager1','Manager1@gmail.com','0123456789','MANAGER',1),(22,'danh','1','danh','d@gmail.com','23456789','USER',1),(23,'Manager2','1','Manager2','Manager2@gmail.com','0123456789','MANAGER',1);
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

-- Dump completed on 2025-09-06 12:57:45
