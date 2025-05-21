-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: hotel
-- ------------------------------------------------------
-- Server version	9.2.0

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
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `reminder_sent` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`booking_id`),
  KEY `fk_guest` (`guest_id`),
  KEY `fk_room` (`room_id`),
  CONSTRAINT `fk_guest` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (30,28,1,'2025-05-17','2025-05-18',1500.00,'2025-05-17 00:07:04',1),(32,30,19,'2025-05-18','2025-05-20',11565.32,'2025-05-17 00:18:19',1),(33,31,17,'2025-05-18','2025-05-19',1725.00,'2025-05-17 02:52:19',1),(34,32,18,'2025-05-20','2025-05-25',1500.00,'2025-05-17 03:16:35',1),(35,33,18,'2025-05-18','2025-05-19',1500.00,'2025-05-18 11:26:18',1),(36,36,22,'2025-05-18','2025-05-19',6500.00,'2025-05-18 20:28:07',1),(37,28,5,'2025-05-20','2025-05-22',5000.00,'2025-05-18 20:43:09',1);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `booking_AFTER_INSERT` AFTER INSERT ON `booking` FOR EACH ROW BEGIN
INSERT INTO history (history_id, guest_id, booking_id, action, action_date_time)
VALUES (NULL, NEW.guest_id, NEW.booking_id, 'Reservation Confirmed', NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `booking_BEFORE_UPDATE` BEFORE UPDATE ON `booking` FOR EACH ROW BEGIN
	DECLARE old_room_price DECIMAL(10,2);
    DECLARE new_room_price DECIMAL(10,2);

    -- Get the price of the current (OLD) room
    SELECT price INTO old_room_price FROM rooms WHERE room_id = OLD.room_id;
    
    -- Get the price of the new (UPDATED) room
    SELECT price INTO new_room_price FROM rooms WHERE room_id = NEW.room_id;

    -- Prevent room downgrades (New room should not be cheaper than the old room)
    IF new_room_price < old_room_price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room downgrade is not allowed';
    END IF;

    -- Ensure total_amount is not below the room's actual price
    IF NEW.total_amount < new_room_price THEN
        SET NEW.total_amount = new_room_price;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `booking_AFTER_UPDATE` AFTER UPDATE ON `booking` FOR EACH ROW BEGIN
-- Log changes in booking_updates table
    IF OLD.room_id <> NEW.room_id THEN
        INSERT INTO booking_updates_log (booking_id, guest_id, updated_column, old_value, new_value)
        VALUES (NEW.booking_id, NEW.guest_id, 'room_id', OLD.room_id, NEW.room_id);
    END IF;

    IF OLD.check_in_date <> NEW.check_in_date THEN
        INSERT INTO booking_updates_log (booking_id, guest_id, updated_column, old_value, new_value)
        VALUES (NEW.booking_id, NEW.guest_id, 'check_in_date', OLD.check_in_date, NEW.check_in_date);
    END IF;

    IF OLD.check_out_date <> NEW.check_out_date THEN
        INSERT INTO booking_updates_log (booking_id, guest_id, updated_column, old_value, new_value)
        VALUES (NEW.booking_id, NEW.guest_id, 'check_out_date', OLD.check_out_date, NEW.check_out_date);
    END IF;

    IF OLD.total_amount <> NEW.total_amount THEN
        INSERT INTO booking_updates_log (booking_id, guest_id, updated_column, old_value, new_value)
        VALUES (NEW.booking_id, NEW.guest_id, 'total_amount', OLD.total_amount, NEW.total_amount);
    END IF;

	-- Check if any relevant fields have changed (excluding created_at and reminder_sent)
    IF OLD.room_id != NEW.room_id OR 
       OLD.check_in_date != NEW.check_in_date OR 
       OLD.check_out_date != NEW.check_out_date OR 
       OLD.total_amount != NEW.total_amount THEN

        -- Insert notification for the update
        INSERT INTO booking_notifications (guest_id, booking_id, message)
        VALUES (
            NEW.guest_id,
            NEW.booking_id,
            CONCAT(
                'Your booking has been updated. Room: ', NEW.room_id, 
                ', Check-in: ', DATE_FORMAT(NEW.check_in_date, '%Y-%m-%d'), 
                ', Check-out: ', DATE_FORMAT(NEW.check_out_date, '%Y-%m-%d'), 
                '. Total: PHP ', NEW.total_amount, '. Thank you!'
            )
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `booking_BEFORE_DELETE` BEFORE DELETE ON `booking` FOR EACH ROW BEGIN
	-- Prevent deletion if current date is within the stay period
    IF CURDATE() BETWEEN OLD.check_in_date AND OLD.check_out_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Deletion is not permitted as the stay period has already begun.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `booking_AFTER_DELETE` AFTER DELETE ON `booking` FOR EACH ROW BEGIN
-- Log the deleted booking for audit purposes
    INSERT INTO deletedbookings_log (booking_id, guest_id, room_id, check_in_date, check_out_date, total_amount, deleted_at)
    VALUES (OLD.booking_id, OLD.guest_id, OLD.room_id, OLD.check_in_date, OLD.check_out_date, OLD.total_amount, NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `booking_notifications`
--

DROP TABLE IF EXISTS `booking_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_notifications` (
  `notif_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `message` text NOT NULL,
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notif_id`),
  KEY `booking_id` (`booking_id`),
  KEY `booking_notifications_ibfk_1` (`guest_id`),
  CONSTRAINT `booking_notifications_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `booking_notifications_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_notifications`
--

LOCK TABLES `booking_notifications` WRITE;
/*!40000 ALTER TABLE `booking_notifications` DISABLE KEYS */;
INSERT INTO `booking_notifications` VALUES (131,32,34,'Reminder: Your reservation is confirmed. Room: 18, Check-in: 2025-05-20, Check-out: 2025-05-25. Total: PHP 1500.00. Thank you!','2025-05-16 19:16:44'),(132,33,35,'Reminder: Your reservation is confirmed. Room: 18, Check-in: 2025-05-18, Check-out: 2025-05-19. Total: PHP 1500.00. Thank you!','2025-05-18 03:26:44'),(133,36,36,'Reminder: Your reservation is confirmed. Room: 5, Check-in: 2025-05-18, Check-out: 2025-05-19. Total: PHP 5000.00. Thank you!','2025-05-18 12:28:44'),(134,28,37,'Reminder: Your reservation is confirmed. Room: 5, Check-in: 2025-05-20, Check-out: 2025-05-22. Total: PHP 5000.00. Thank you!','2025-05-18 12:43:44'),(135,36,36,'Your booking has been updated. Room: 22, Check-in: 2025-05-18, Check-out: 2025-05-19. Total: PHP 6500.00. Thank you!','2025-05-18 14:37:11');
/*!40000 ALTER TABLE `booking_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_updates_log`
--

DROP TABLE IF EXISTS `booking_updates_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_updates_log` (
  `booking_update_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `guest_id` int DEFAULT NULL,
  `updated_column` varchar(50) DEFAULT NULL,
  `old_value` varchar(255) DEFAULT NULL,
  `new_value` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_update_id`),
  KEY `booking_id` (`booking_id`),
  KEY `booking_updates_log_ibfk_2` (`guest_id`),
  CONSTRAINT `booking_updates_log_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`),
  CONSTRAINT `booking_updates_log_ibfk_2` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_updates_log`
--

LOCK TABLES `booking_updates_log` WRITE;
/*!40000 ALTER TABLE `booking_updates_log` DISABLE KEYS */;
INSERT INTO `booking_updates_log` VALUES (33,32,30,'room_id','17','1','2025-05-17 00:47:29'),(34,32,30,'room_id','1','19','2025-05-17 00:47:45'),(35,32,30,'total_amount','1500.00','5000.00','2025-05-17 00:47:45'),(36,32,30,'total_amount','5000.00','5750.00','2025-05-17 02:31:10'),(37,32,30,'total_amount','5750.00','6612.50','2025-05-17 02:34:42'),(38,32,30,'total_amount','6612.50','7604.38','2025-05-17 02:35:05'),(39,32,30,'total_amount','7604.38','8745.04','2025-05-17 02:36:20'),(40,32,30,'total_amount','8745.04','10056.80','2025-05-17 02:38:19'),(41,32,30,'total_amount','10056.80','11565.32','2025-05-17 02:39:07'),(42,32,30,'check_in_date','2025-05-17','2025-05-18','2025-05-17 02:57:13'),(43,32,30,'check_out_date','2025-05-19','2025-05-20','2025-05-17 02:57:13'),(44,33,31,'total_amount','1500.00','1725.00','2025-05-17 03:01:47'),(45,36,36,'room_id','5','22','2025-05-18 22:37:11'),(46,36,36,'total_amount','5000.00','6500.00','2025-05-18 22:37:11');
/*!40000 ALTER TABLE `booking_updates_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `bookingdetails`
--

DROP TABLE IF EXISTS `bookingdetails`;
/*!50001 DROP VIEW IF EXISTS `bookingdetails`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `bookingdetails` AS SELECT 
 1 AS `booking_id`,
 1 AS `guest_id`,
 1 AS `room_id`,
 1 AS `check_in_date`,
 1 AS `check_out_date`,
 1 AS `total_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `deletedbookings_log`
--

DROP TABLE IF EXISTS `deletedbookings_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deletedbookings_log` (
  `deleted_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `guest_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`deleted_id`),
  KEY `deletedbookings_log_ibfk_1` (`guest_id`),
  KEY `deletedbookings_log_ibfk_2` (`room_id`),
  CONSTRAINT `deletedbookings_log_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `deletedbookings_log_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deletedbookings_log`
--

LOCK TABLES `deletedbookings_log` WRITE;
/*!40000 ALTER TABLE `deletedbookings_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `deletedbookings_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `guest_id` int NOT NULL AUTO_INCREMENT,
  `fname` varchar(45) NOT NULL,
  `lname` varchar(45) NOT NULL,
  `dob` date NOT NULL,
  `baranggay` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `province` varchar(100) NOT NULL,
  `postal_code` varchar(10) NOT NULL,
  PRIMARY KEY (`guest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest`
--

LOCK TABLES `guest` WRITE;
/*!40000 ALTER TABLE `guest` DISABLE KEYS */;
INSERT INTO `guest` VALUES (28,'Keyan','Canary','1997-01-21','Abuyog','Sorsogon city','Sorsogon','4700'),(30,'Kaye','Dollesin','2002-07-31','Ems barrio','Legazpi city','Albay','4750'),(31,'Ruffa','Quinto','1990-06-20','Cabiguhan','Gubat','Sorsogon','4158'),(32,'Jennifer','Lopez','1895-03-26','Pangpang','Sorsogon','Sorsogon','4700'),(33,'Kristelle','Miranda','2002-11-23','Antonio','Donsol','Sorsogon','4702'),(36,'Lita','Mora','1994-10-08','Abuyog','Sorsogon','Sorsogon','4700');
/*!40000 ALTER TABLE `guest` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `guest_BEFORE_INSERT` BEFORE INSERT ON `guest` FOR EACH ROW BEGIN
	SET NEW.fname = CONCAT(UPPER(LEFT(NEW.fname, 1)), LOWER(SUBSTRING(NEW.fname, 2)));
    SET NEW.lname = CONCAT(UPPER(LEFT(NEW.lname, 1)), LOWER(SUBSTRING(NEW.lname, 2)));
    SET NEW.baranggay = CONCAT(UPPER(LEFT(NEW.baranggay, 1)), LOWER(SUBSTRING(NEW.baranggay, 2)));
    SET NEW.city = CONCAT(UPPER(LEFT(NEW.city, 1)), LOWER(SUBSTRING(NEW.city, 2)));
    SET NEW.province = CONCAT(UPPER(LEFT(NEW.province, 1)), LOWER(SUBSTRING(NEW.province, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `guestbookingdetails`
--

DROP TABLE IF EXISTS `guestbookingdetails`;
/*!50001 DROP VIEW IF EXISTS `guestbookingdetails`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `guestbookingdetails` AS SELECT 
 1 AS `guest_id`,
 1 AS `full_name`,
 1 AS `dob`,
 1 AS `full_address`,
 1 AS `booking_id`,
 1 AS `room_id`,
 1 AS `check_in_date`,
 1 AS `check_out_date`,
 1 AS `total_amount`,
 1 AS `bill_mode`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `guestdetails`
--

DROP TABLE IF EXISTS `guestdetails`;
/*!50001 DROP VIEW IF EXISTS `guestdetails`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `guestdetails` AS SELECT 
 1 AS `guest_id`,
 1 AS `fname`,
 1 AS `lname`,
 1 AS `dob`,
 1 AS `full_address`,
 1 AS `postal_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `action` varchar(255) NOT NULL,
  `action_date_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `booking_id` (`booking_id`),
  KEY `history_ibfk_1` (`guest_id`),
  CONSTRAINT `history_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `history_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
INSERT INTO `history` VALUES (19,28,30,'Reservation Confirmed','2025-05-17 00:07:04'),(21,30,32,'Reservation Confirmed','2025-05-17 00:18:19'),(22,31,33,'Reservation Confirmed','2025-05-17 02:52:19'),(23,32,34,'Reservation Confirmed','2025-05-17 03:16:35'),(24,33,35,'Reservation Confirmed','2025-05-18 11:26:18'),(25,36,36,'Reservation Confirmed','2025-05-18 20:28:07'),(26,28,37,'Reservation Confirmed','2025-05-18 20:43:09');
/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `housekeeping`
--

DROP TABLE IF EXISTS `housekeeping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `housekeeping` (
  `housekeeping_id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `room_id` int NOT NULL,
  `status` enum('Pending','Completed') NOT NULL,
  PRIMARY KEY (`housekeeping_id`),
  KEY `staff_id` (`staff_id`,`room_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `room_id` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `housekeeping`
--

LOCK TABLES `housekeeping` WRITE;
/*!40000 ALTER TABLE `housekeeping` DISABLE KEYS */;
INSERT INTO `housekeeping` VALUES (1,3,1,'Pending'),(5,9,5,'Pending'),(9,4,9,'Completed'),(10,2,10,'Pending');
/*!40000 ALTER TABLE `housekeeping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `housekeepingstatus`
--

DROP TABLE IF EXISTS `housekeepingstatus`;
/*!50001 DROP VIEW IF EXISTS `housekeepingstatus`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `housekeepingstatus` AS SELECT 
 1 AS `housekeeping_id`,
 1 AS `staff_id`,
 1 AS `room_id`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `monthlyrevenue`
--

DROP TABLE IF EXISTS `monthlyrevenue`;
/*!50001 DROP VIEW IF EXISTS `monthlyrevenue`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `monthlyrevenue` AS SELECT 
 1 AS `year&month`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `bill_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `bill_date` date NOT NULL,
  `bill_amount` decimal(10,2) NOT NULL,
  `bill_mode` enum('cash','card','online') NOT NULL,
  `payment_status` varchar(45) NOT NULL,
  PRIMARY KEY (`bill_id`),
  KEY `booking_id_idx` (`booking_id`),
  CONSTRAINT `booking_id` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (19,30,'2025-05-17',1500.00,'card','Paid'),(21,32,'2025-05-17',1500.00,'card','Paid'),(22,33,'2025-05-17',1500.00,'card','Paid'),(23,34,'2025-05-17',1500.00,'card','Paid'),(24,35,'2025-05-18',1500.00,'cash','Paid'),(25,36,'2025-05-18',5000.00,'card','Paid'),(26,37,'2025-05-18',5000.00,'cash','Paid');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roomavailabilityreport`
--

DROP TABLE IF EXISTS `roomavailabilityreport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roomavailabilityreport` (
  `room_id` int DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `check_in_date` date DEFAULT NULL,
  `check_out_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roomavailabilityreport`
--

LOCK TABLES `roomavailabilityreport` WRITE;
/*!40000 ALTER TABLE `roomavailabilityreport` DISABLE KEYS */;
/*!40000 ALTER TABLE `roomavailabilityreport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `roomavailabilitysummaryview`
--

DROP TABLE IF EXISTS `roomavailabilitysummaryview`;
/*!50001 DROP VIEW IF EXISTS `roomavailabilitysummaryview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `roomavailabilitysummaryview` AS SELECT 
 1 AS `room_id`,
 1 AS `room_type`,
 1 AS `room_status`,
 1 AS `booking_id`,
 1 AS `guest_first_name`,
 1 AS `guest_last_name`,
 1 AS `check_in_date`,
 1 AS `check_out_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `roomguestcount`
--

DROP TABLE IF EXISTS `roomguestcount`;
/*!50001 DROP VIEW IF EXISTS `roomguestcount`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `roomguestcount` AS SELECT 
 1 AS `room_id`,
 1 AS `guest_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `room_type` varchar(45) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` enum('Available','Occupied') NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'Single 101',1500.00,'Available'),(5,'Suite 104',5000.00,'Occupied'),(9,'Penthouse 110',10000.00,'Available'),(10,'Penthouse 111',10000.00,'Available'),(11,'MasterBed 107',6500.00,'Available'),(17,'Single 102',1500.00,'Available'),(18,'Single 103',1500.00,'Available'),(19,'Suite 105',5000.00,'Available'),(20,'Suite 106',5000.00,'Available'),(22,'MasterBed 108',6500.00,'Available'),(23,'MasterBed 109',6500.00,'Available'),(24,'Penthouse 112',10000.00,'Available');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `roomstatus`
--

DROP TABLE IF EXISTS `roomstatus`;
/*!50001 DROP VIEW IF EXISTS `roomstatus`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `roomstatus` AS SELECT 
 1 AS `room_id`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `seasonal_roompricing`
--

DROP TABLE IF EXISTS `seasonal_roompricing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seasonal_roompricing` (
  `pricing_id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `seasonal_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`pricing_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seasonal_roompricing`
--

LOCK TABLES `seasonal_roompricing` WRITE;
/*!40000 ALTER TABLE `seasonal_roompricing` DISABLE KEYS */;
/*!40000 ALTER TABLE `seasonal_roompricing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`service_id`),
  KEY `fk_booking` (`booking_id`),
  CONSTRAINT `fk_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staff_id` int NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `role` varchar(45) NOT NULL,
  PRIMARY KEY (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'John','Doe','Manager'),(2,'Alice','Smith','Receptionist'),(3,'Bob','Johnson','Housekeeper'),(4,'Claire','Williams','Chef'),(5,'James','Brown','Waiter'),(6,'Olivia','Davis','Housekeeper'),(7,'David','Martinez','Security'),(8,'Sophia','Rodriguez','Receptionist'),(9,'Daniel','Garcia','Housekeeper'),(10,'Emily','Wilson','Waiter');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_users`
--

DROP TABLE IF EXISTS `system_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(10) DEFAULT 'active',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_users`
--

LOCK TABLES `system_users` WRITE;
/*!40000 ALTER TABLE `system_users` DISABLE KEYS */;
INSERT INTO `system_users` VALUES (1,'admin','dollesinkarylle@gmail.com','$2a$11$hI.5jqcBI8f85TueKGM8tO3BKWMYZbT839ZMps6BWtQS/sBe6P0KC','2025-05-14 03:35:18','active'),(2,'adminstaff1','nikkiblen@gmail.com','f71c819a5ad3c36fe55d32d3072a7998b3a014ea59b4d1a2afef8cc49e8cde9f','2025-05-14 03:41:05','Inactive'),(11,'staffabc','staffabc@gmail.com','$2a$11$lWDG8ScPe4FxNm2lh4JNMu3hviM4bNXR8YekcYAWO5T/TjXN81bv.','2025-05-18 15:03:10','Active');
/*!40000 ALTER TABLE `system_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'hotel'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `cleanup_expired_seasonal_prices` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `cleanup_expired_seasonal_prices` ON SCHEDULE AT '2025-04-03 17:29:48' ON COMPLETION PRESERVE DISABLE DO BEGIN
    DELETE FROM seasonal_roompricing;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `send_reservation_reminders` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `send_reservation_reminders` ON SCHEDULE EVERY 1 MINUTE STARTS '2025-04-03 16:40:44' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    -- Insert reminders into the booking_notifications table
    INSERT INTO booking_notifications (guest_id, booking_id, message, sent_at)
    SELECT 
        b.guest_id,
        b.booking_id,
        CONCAT(
            'Reminder: Your reservation is confirmed. Room: ', b.room_id, 
            ', Check-in: ', DATE_FORMAT(b.check_in_date, '%Y-%m-%d'), 
            ', Check-out: ', DATE_FORMAT(b.check_out_date, '%Y-%m-%d'), 
            '. Total: PHP ', b.total_amount, '. Thank you!'
        ),
        NOW()
    FROM booking b
    WHERE b.reminder_sent = FALSE;

	UPDATE booking
    SET reminder_sent = TRUE
    WHERE reminder_sent = FALSE;
    
	-- WHERE DATE(b.created_at) = CURDATE();
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `update_room_prices` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `update_room_prices` ON SCHEDULE AT '2025-04-03 17:24:42' ON COMPLETION PRESERVE DISABLE DO BEGIN
   -- Insert Holy Week prices into the seasonal_roompricing table
    INSERT INTO seasonal_roompricing (room_id, start_date, end_date, seasonal_price)
    SELECT 
        room_id,
        '2025-04-13', -- Start of Holy Week
        '2025-04-20', -- End of Holy Week
        CASE
            WHEN room_type = 'Single' THEN price * 1.05
            WHEN room_type = 'Double' THEN price * 1.06
            WHEN room_type = 'Deluxe' THEN price * 1.07
            WHEN room_type = 'Suite' THEN price * 1.10
            WHEN room_type = 'Penthouse' THEN price * 1.12
            WHEN room_type = 'MasterBed' THEN price * 1.11
        END AS seasonal_price
    FROM rooms;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'hotel'
--
/*!50003 DROP FUNCTION IF EXISTS `GetAvailableRoomsCount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetAvailableRoomsCount`() RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE availableRooms INT;
    
    -- Count the number of available rooms from RoomAvailabilityReport of 
    SELECT COUNT(*) INTO availableRooms 
    FROM RoomAvailabilityReport 
    WHERE status = 'Available';

    RETURN availableRooms;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetMonthlyBookings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetMonthlyBookings`(year INT, month INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE totalBookings INT;
    
    -- Get the total number of booking per month and year
    SELECT COUNT(*) INTO totalBookings
    FROM booking
    WHERE YEAR(check_in_date) = year AND MONTH(check_in_date) = month;
    
    RETURN totalBookings;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetPaymentStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetPaymentStatus`(bookingID INT) RETURNS char(20) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE payment_status CHAR(20);

    -- Check if bookingID exists in the booking table
    IF NOT EXISTS (SELECT 1 FROM booking WHERE booking_id = bookingID) THEN
        SET payment_status = 'Invalid Booking ID';
    ELSEIF EXISTS (SELECT 1 FROM payment WHERE booking_id = bookingID) THEN
        SET payment_status = 'Paid';
    ELSE
        SET payment_status = 'Pending';
    END IF;

    RETURN payment_status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetStayDuration` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetStayDuration`(bookingID INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE stayDuration INT;

	-- Check if booking ID exists
    IF NOT EXISTS (SELECT 1 FROM bookingdetails WHERE booking_id = bookingID) THEN
        RETURN NULL; 
    END IF;
    
    SELECT DATEDIFF(check_out_date, check_in_date) 
    INTO stayDuration
    FROM bookingdetails
    WHERE booking_id = bookingID;

    RETURN stayDuration;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetTotalBill` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalBill`(amount DECIMAL(10,2)) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE taxRate DECIMAL(5,2);
    DECLARE totalAmount DECIMAL(10,2); -- from GenerateInvoice

    -- Define tax rate (e.g., 12% VAT)
    SET taxRate = 0.15;  

    -- Calculate the final amount including tax
    SET totalAmount = amount + (amount * taxRate);

    RETURN totalAmount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CalcTotalRevenue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalcTotalRevenue`()
BEGIN
select sum(total_revenue) from monthlyrevenue;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GenerateInvoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateInvoice`(IN bookingID INT)
BEGIN
    DECLARE guestID INT;
    DECLARE totalAmount DECIMAL(10,2);
    DECLARE finalAmount DECIMAL(10,2);
    DECLARE billMode VARCHAR(50);
    DECLARE invoiceDate DATE;
    DECLARE paymentStatus CHAR(20);

    -- Get guest ID, total amount, and payment details from booking
    SELECT b.guest_id, b.total_amount, COALESCE(p.bill_mode, 'Not Specified') 
    INTO guestID, totalAmount, billMode
    FROM booking b
    LEFT JOIN payment p ON b.booking_id = p.booking_id
    WHERE b.booking_id = bookingID;

    -- Apply tax using function
    SET finalAmount = GetTotalBill(totalAmount);

	-- Apply GetPaymentStatus Function
    SET paymentStatus = GetPaymentStatus(bookingID);

    -- Date today
    SET invoiceDate = CURDATE();

    -- Display the guest booking details along with the calculated total bill and payment status
    SELECT 
        g.guest_id, 
        b.booking_id, 
        COALESCE(p.bill_id, 'No Bill') AS bill_id, 
        g.fname, 
        g.lname, 
        CONCAT(g.baranggay, ', ', g.city, ', ', g.province) AS full_address, 
        r.room_type, -- changed from room_id to room_type
        b.check_in_date, 
        b.check_out_date, 
        b.total_amount AS original_amount, 
        finalAmount AS total_with_tax,
        COALESCE(p.bill_mode, 'Not Specified') AS bill_mode,
        COALESCE(p.bill_date, 'No Payment Date') AS bill_date,
        invoiceDate AS invoice_date,
        paymentStatus AS payment_status
    FROM guest g
    JOIN booking b ON g.guest_id = b.guest_id
    JOIN rooms r ON b.room_id = r.room_id -- added JOIN to fetch room_type
    LEFT JOIN payment p ON b.booking_id = p.booking_id
    WHERE b.booking_id = bookingID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GenerateRoomReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateRoomReport`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE roomID INT;
    DECLARE roomType VARCHAR(50);
    DECLARE latestCheckin DATE;
    DECLARE latestCheckout DATE;
    DECLARE roomStatus VARCHAR(20);

    -- Declare a cursor to fetch all room IDs
    DECLARE roomCursor CURSOR FOR 
        SELECT room_id FROM rooms;

    -- Declare a handler for the end of the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Create a temporary table to store the report
    CREATE TEMPORARY TABLE IF NOT EXISTS RoomAvailabilityReport (
        room_id INT,
        room_type VARCHAR(50),
        status VARCHAR(20),
        check_in_date DATE,
        check_out_date DATE
    );

	-- Clear previous data to avoid duplicates
    TRUNCATE TABLE RoomAvailabilityReport;
    -- Open the cursor
    OPEN roomCursor;

    room_loop: LOOP
        -- Fetch the next room ID
        FETCH roomCursor INTO roomID;
        IF done THEN
            LEAVE room_loop;
        END IF;

        -- Get the latest booking details for the room
        SELECT MAX(check_in_date), MAX(check_out_date) 
        INTO latestCheckin, latestCheckout 
        FROM booking 
        WHERE room_id = roomID;
        
        SELECT room_type INTO roomType
		FROM rooms
		WHERE room_id = roomID;

        -- Determine room status
        IF latestCheckout IS NULL OR latestCheckout < CURDATE() THEN
            SET roomStatus = 'Available';
            SET latestCheckin = NULL;
            SET latestCheckout = NULL;
        ELSE
            SET roomStatus = 'Occupied';
        END IF;

        -- Insert the report data
       INSERT INTO RoomAvailabilityReport (room_id, room_type, status, check_in_date, check_out_date)
		VALUES (roomID, roomType, roomStatus, latestCheckin, latestCheckout);

    END LOOP;

    -- Close the cursor
    CLOSE roomCursor;

    -- Display the generated report
    SELECT * FROM RoomAvailabilityReport;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateRoomStatusWithCursor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRoomStatusWithCursor`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE r_id INT;
    DECLARE new_status VARCHAR(20);

    -- Cursor to fetch all rooms with bookings
    DECLARE booking_cursor CURSOR FOR
        SELECT room_id, 
               CASE 
                   WHEN CURDATE() BETWEEN check_in_date AND check_out_date THEN 'Occupied'
                   ELSE 'Available'
               END AS status_update
        FROM booking;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN booking_cursor;
    
    read_loop: LOOP
        FETCH booking_cursor INTO r_id, new_status;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Update the room status dynamically
        UPDATE rooms SET status = new_status WHERE room_id = r_id;
    END LOOP;

    CLOSE booking_cursor;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `bookingdetails`
--

/*!50001 DROP VIEW IF EXISTS `bookingdetails`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `bookingdetails` AS select `booking`.`booking_id` AS `booking_id`,`booking`.`guest_id` AS `guest_id`,`booking`.`room_id` AS `room_id`,`booking`.`check_in_date` AS `check_in_date`,`booking`.`check_out_date` AS `check_out_date`,`booking`.`total_amount` AS `total_amount` from `booking` */
/*!50002 WITH CASCADED CHECK OPTION */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `guestbookingdetails`
--

/*!50001 DROP VIEW IF EXISTS `guestbookingdetails`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `guestbookingdetails` AS select `g`.`guest_id` AS `guest_id`,concat(`g`.`fname`,' ',`g`.`lname`) AS `full_name`,`g`.`dob` AS `dob`,concat(`g`.`baranggay`,', ',`g`.`city`,', ',`g`.`province`) AS `full_address`,`b`.`booking_id` AS `booking_id`,`b`.`room_id` AS `room_id`,`b`.`check_in_date` AS `check_in_date`,`b`.`check_out_date` AS `check_out_date`,`b`.`total_amount` AS `total_amount`,`p`.`bill_mode` AS `bill_mode` from ((`guest` `g` join `booking` `b` on((`g`.`guest_id` = `b`.`guest_id`))) left join `payment` `p` on((`b`.`booking_id` = `p`.`booking_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `guestdetails`
--

/*!50001 DROP VIEW IF EXISTS `guestdetails`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `guestdetails` AS select `guest`.`guest_id` AS `guest_id`,`guest`.`fname` AS `fname`,`guest`.`lname` AS `lname`,`guest`.`dob` AS `dob`,concat(`guest`.`baranggay`,', ',`guest`.`city`,', ',`guest`.`province`) AS `full_address`,`guest`.`postal_code` AS `postal_code` from `guest` */
/*!50002 WITH CASCADED CHECK OPTION */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `housekeepingstatus`
--

/*!50001 DROP VIEW IF EXISTS `housekeepingstatus`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `housekeepingstatus` AS select `housekeeping`.`housekeeping_id` AS `housekeeping_id`,`housekeeping`.`staff_id` AS `staff_id`,`housekeeping`.`room_id` AS `room_id`,`housekeeping`.`status` AS `status` from `housekeeping` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `monthlyrevenue`
--

/*!50001 DROP VIEW IF EXISTS `monthlyrevenue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `monthlyrevenue` AS select date_format(`booking`.`check_in_date`,'%Y-%m') AS `year&month`,sum(`booking`.`total_amount`) AS `total_revenue` from `booking` group by `year&month` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `roomavailabilitysummaryview`
--

/*!50001 DROP VIEW IF EXISTS `roomavailabilitysummaryview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `roomavailabilitysummaryview` AS select `r`.`room_id` AS `room_id`,`r`.`room_type` AS `room_type`,`r`.`status` AS `room_status`,`b`.`booking_id` AS `booking_id`,`g`.`fname` AS `guest_first_name`,`g`.`lname` AS `guest_last_name`,`b`.`check_in_date` AS `check_in_date`,`b`.`check_out_date` AS `check_out_date` from ((`rooms` `r` left join `booking` `b` on((`r`.`room_id` = `b`.`room_id`))) left join `guest` `g` on((`b`.`guest_id` = `g`.`guest_id`))) where ((`r`.`status` = 'Occupied') or ((`r`.`status` = 'Available') and (`b`.`booking_id` is null))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `roomguestcount`
--

/*!50001 DROP VIEW IF EXISTS `roomguestcount`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `roomguestcount` AS select `b`.`room_id` AS `room_id`,count(`b`.`guest_id`) AS `guest_count` from `booking` `b` group by `b`.`room_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `roomstatus`
--

/*!50001 DROP VIEW IF EXISTS `roomstatus`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `roomstatus` AS select `r`.`room_id` AS `room_id`,`r`.`status` AS `status` from `rooms` `r` where (`r`.`status` = 'Available') */;
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

-- Dump completed on 2025-05-21 18:12:24
