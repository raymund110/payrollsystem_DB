-- MySQL dump 10.13  Distrib 9.6.0, for macos14.8 (x86_64)
--
-- Host: localhost    Database: payrollsystem_db
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '5b70a220-6c99-11f1-b8c0-59a639271a0e:1-75';

--
-- Table structure for table `allowance_type`
--

DROP TABLE IF EXISTS `allowance_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allowance_type` (
  `allowance_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`allowance_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attendance_record`
--

DROP TABLE IF EXISTS `attendance_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_record` (
  `attendance_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_pk` bigint unsigned NOT NULL,
  `attendance_date` date NOT NULL,
  `time_in` time DEFAULT NULL,
  `time_out` time DEFAULT NULL,
  `hours_worked` decimal(5,2) DEFAULT '0.00',
  `late_minutes` int DEFAULT '0',
  `undertime_minutes` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`attendance_id`),
  UNIQUE KEY `uq_employee_attendance` (`employee_pk`,`attendance_date`),
  KEY `idx_attendance_date` (`attendance_date`),
  KEY `idx_attendance_employee` (`employee_pk`),
  CONSTRAINT `fk_attendance_employee` FOREIGN KEY (`employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE CASCADE,
  CONSTRAINT `chk_hours_worked` CHECK ((`hours_worked` >= 0)),
  CONSTRAINT `chk_late_minutes` CHECK ((`late_minutes` >= 0)),
  CONSTRAINT `chk_undertime_minutes` CHECK ((`undertime_minutes` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attendance_staging`
--

DROP TABLE IF EXISTS `attendance_staging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_staging` (
  `attendance_staging_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_no` varchar(10) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `attendance_date` date DEFAULT NULL,
  `log_in` time DEFAULT NULL,
  `log_out` time DEFAULT NULL,
  `loaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`attendance_staging_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(50) NOT NULL,
  `description` text,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_name` (`department_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `employee_pk` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_no` varchar(10) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `birthday` date NOT NULL,
  `address` text,
  `phone_number` varchar(20) DEFAULT NULL,
  `sss_number` varchar(30) DEFAULT NULL,
  `philhealth_number` varchar(30) DEFAULT NULL,
  `tin_number` varchar(30) DEFAULT NULL,
  `pagibig_number` varchar(30) DEFAULT NULL,
  `supervisor_employee_pk` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_pk`),
  UNIQUE KEY `employee_no` (`employee_no`),
  UNIQUE KEY `sss_number` (`sss_number`),
  UNIQUE KEY `philhealth_number` (`philhealth_number`),
  UNIQUE KEY `tin_number` (`tin_number`),
  UNIQUE KEY `pagibig_number` (`pagibig_number`),
  KEY `idx_employee_supervisor` (`supervisor_employee_pk`),
  KEY `idx_employee_no` (`employee_no`),
  CONSTRAINT `fk_employee_supervisor` FOREIGN KEY (`supervisor_employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee_employment_history`
--

DROP TABLE IF EXISTS `employee_employment_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_employment_history` (
  `history_id` bigint NOT NULL AUTO_INCREMENT,
  `employee_pk` bigint unsigned NOT NULL,
  `status_name` varchar(30) NOT NULL,
  `effective_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `idx_employment_history_employee` (`employee_pk`),
  CONSTRAINT `fk_eh_employee` FOREIGN KEY (`employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee_position`
--

DROP TABLE IF EXISTS `employee_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_position` (
  `employee_pk` bigint unsigned NOT NULL,
  `position_id` int NOT NULL,
  `department_id` int NOT NULL,
  `effective_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `basic_salary` decimal(10,2) NOT NULL,
  PRIMARY KEY (`employee_pk`,`position_id`,`effective_date`),
  KEY `fk_ep_position` (`position_id`),
  KEY `fk_ep_department` (`department_id`),
  KEY `idx_employee_position_employee` (`employee_pk`),
  CONSTRAINT `fk_ep_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `fk_ep_employee` FOREIGN KEY (`employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE CASCADE,
  CONSTRAINT `fk_ep_position` FOREIGN KEY (`position_id`) REFERENCES `job_position` (`position_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee_staging`
--

DROP TABLE IF EXISTS `employee_staging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_staging` (
  `staging_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_no` varchar(10) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `address` text,
  `phone` varchar(30) DEFAULT NULL,
  `sss` varchar(30) DEFAULT NULL,
  `philhealth` varchar(30) DEFAULT NULL,
  `tin` varchar(30) DEFAULT NULL,
  `pagibig` varchar(30) DEFAULT NULL,
  `employment_status` varchar(30) DEFAULT NULL,
  `job_position` varchar(100) DEFAULT NULL,
  `supervisor_name` varchar(100) DEFAULT NULL,
  `basic_salary` decimal(10,2) DEFAULT NULL,
  `rice_subsidy` decimal(10,2) DEFAULT NULL,
  `phone_allowance` decimal(10,2) DEFAULT NULL,
  `clothing_allowance` decimal(10,2) DEFAULT NULL,
  `gross_semi_monthly` decimal(10,2) DEFAULT NULL,
  `hourly_rate` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`staging_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employment_status`
--

DROP TABLE IF EXISTS `employment_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employment_status` (
  `status_id` int NOT NULL AUTO_INCREMENT,
  `status_name` varchar(30) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_position`
--

DROP TABLE IF EXISTS `job_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_position` (
  `position_id` int NOT NULL AUTO_INCREMENT,
  `position_name` varchar(50) NOT NULL,
  PRIMARY KEY (`position_id`),
  UNIQUE KEY `position_name` (`position_name`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leave_request`
--

DROP TABLE IF EXISTS `leave_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_request` (
  `leave_request_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_pk` bigint unsigned NOT NULL,
  `leave_type_id` int NOT NULL,
  `leave_status_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `reason` text,
  `approved_by` bigint unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`leave_request_id`),
  KEY `fk_leave_type` (`leave_type_id`),
  KEY `fk_leave_status` (`leave_status_id`),
  KEY `fk_leave_approver` (`approved_by`),
  KEY `idx_leave_employee` (`employee_pk`),
  CONSTRAINT `fk_leave_approver` FOREIGN KEY (`approved_by`) REFERENCES `employee` (`employee_pk`),
  CONSTRAINT `fk_leave_employee` FOREIGN KEY (`employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE CASCADE,
  CONSTRAINT `fk_leave_status` FOREIGN KEY (`leave_status_id`) REFERENCES `leave_status` (`leave_status_id`),
  CONSTRAINT `fk_leave_type` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_type` (`leave_type_id`),
  CONSTRAINT `leave_request_chk_1` CHECK ((`end_date` >= `start_date`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leave_status`
--

DROP TABLE IF EXISTS `leave_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_status` (
  `leave_status_id` int NOT NULL AUTO_INCREMENT,
  `status_name` varchar(30) NOT NULL,
  PRIMARY KEY (`leave_status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leave_type`
--

DROP TABLE IF EXISTS `leave_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_type` (
  `leave_type_id` int NOT NULL AUTO_INCREMENT,
  `leave_name` varchar(50) NOT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT '1',
  `max_days_per_year` int NOT NULL,
  PRIMARY KEY (`leave_type_id`),
  UNIQUE KEY `leave_name` (`leave_name`),
  CONSTRAINT `leave_type_chk_1` CHECK ((`max_days_per_year` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `overtime_entry`
--

DROP TABLE IF EXISTS `overtime_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `overtime_entry` (
  `overtime_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_pk` bigint unsigned NOT NULL,
  `overtime_type_id` int NOT NULL,
  `overtime_date` date NOT NULL,
  `hours` decimal(5,2) NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`overtime_id`),
  KEY `fk_overtime_type` (`overtime_type_id`),
  KEY `idx_overtime_approver` (`approved_by`),
  KEY `idx_overtime_employee` (`employee_pk`),
  CONSTRAINT `fk_overtime_approver` FOREIGN KEY (`approved_by`) REFERENCES `employee` (`employee_pk`) ON DELETE SET NULL,
  CONSTRAINT `fk_overtime_employee` FOREIGN KEY (`employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE CASCADE,
  CONSTRAINT `fk_overtime_type` FOREIGN KEY (`overtime_type_id`) REFERENCES `overtime_type` (`overtime_type_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_overtime_hours` CHECK ((`hours` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `overtime_type`
--

DROP TABLE IF EXISTS `overtime_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `overtime_type` (
  `overtime_type_id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  `rate_multiplier` decimal(4,2) NOT NULL,
  PRIMARY KEY (`overtime_type_id`),
  UNIQUE KEY `description` (`description`),
  CONSTRAINT `overtime_type_chk_1` CHECK ((`rate_multiplier` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payroll`
--

DROP TABLE IF EXISTS `payroll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll` (
  `payroll_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_pk` bigint unsigned NOT NULL,
  `payroll_status_id` int NOT NULL,
  `pay_period_start` date NOT NULL,
  `pay_period_end` date NOT NULL,
  `gross_pay` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_deductions` decimal(12,2) NOT NULL DEFAULT '0.00',
  `net_pay` decimal(12,2) NOT NULL DEFAULT '0.00',
  `generated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payroll_id`),
  UNIQUE KEY `uq_employee_payroll_period` (`employee_pk`,`pay_period_start`,`pay_period_end`),
  KEY `fk_payroll_status` (`payroll_status_id`),
  KEY `idx_payroll_employee` (`employee_pk`),
  CONSTRAINT `fk_payroll_employee` FOREIGN KEY (`employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE CASCADE,
  CONSTRAINT `fk_payroll_status` FOREIGN KEY (`payroll_status_id`) REFERENCES `payroll_status` (`payroll_status_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_payroll_dates` CHECK ((`pay_period_end` >= `pay_period_start`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payroll_deduction`
--

DROP TABLE IF EXISTS `payroll_deduction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_deduction` (
  `deduction_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payroll_id` bigint unsigned NOT NULL,
  `deduction_type_id` int NOT NULL,
  `bracket_id` int DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  PRIMARY KEY (`deduction_id`),
  KEY `fk_payroll_deduction_payroll` (`payroll_id`),
  KEY `fk_payroll_deduction_type` (`deduction_type_id`),
  KEY `fk_payroll_deduction_bracket` (`bracket_id`),
  CONSTRAINT `fk_payroll_deduction_bracket` FOREIGN KEY (`bracket_id`) REFERENCES `withholding_tax_bracket` (`bracket_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_payroll_deduction_payroll` FOREIGN KEY (`payroll_id`) REFERENCES `payroll` (`payroll_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payroll_deduction_type` FOREIGN KEY (`deduction_type_id`) REFERENCES `payroll_deduction_type` (`deduction_type_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_payroll_deduction_amount` CHECK ((`amount` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payroll_deduction_type`
--

DROP TABLE IF EXISTS `payroll_deduction_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_deduction_type` (
  `deduction_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `government_mandated` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`deduction_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payroll_earning`
--

DROP TABLE IF EXISTS `payroll_earning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_earning` (
  `earning_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payroll_id` bigint unsigned NOT NULL,
  `earning_type_id` int NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  PRIMARY KEY (`earning_id`),
  KEY `fk_payroll_earning_payroll` (`payroll_id`),
  KEY `fk_payroll_earning_type` (`earning_type_id`),
  CONSTRAINT `fk_payroll_earning_payroll` FOREIGN KEY (`payroll_id`) REFERENCES `payroll` (`payroll_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payroll_earning_type` FOREIGN KEY (`earning_type_id`) REFERENCES `payroll_earning_type` (`earning_type_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_payroll_earning_amount` CHECK ((`amount` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payroll_earning_type`
--

DROP TABLE IF EXISTS `payroll_earning_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_earning_type` (
  `earning_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `taxable` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`earning_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payroll_status`
--

DROP TABLE IF EXISTS `payroll_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_status` (
  `payroll_status_id` int NOT NULL AUTO_INCREMENT,
  `status_name` varchar(30) NOT NULL,
  PRIMARY KEY (`payroll_status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission` (
  `permission_id` int unsigned NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(100) NOT NULL,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `permission_name` (`permission_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` int unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_permission`
--

DROP TABLE IF EXISTS `role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permission` (
  `role_id` int unsigned NOT NULL,
  `permission_id` int unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `role_permission_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `role_permission_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_account`
--

DROP TABLE IF EXISTS `user_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_account` (
  `employee_pk` bigint unsigned NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_pk`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_user_role` (`role_id`),
  CONSTRAINT `fk_user_employee` FOREIGN KEY (`employee_pk`) REFERENCES `employee` (`employee_pk`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `vw_employee_payslip`
--

DROP TABLE IF EXISTS `vw_employee_payslip`;
/*!50001 DROP VIEW IF EXISTS `vw_employee_payslip`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_employee_payslip` AS SELECT 
 1 AS `employee_id`,
 1 AS `employee_name`,
 1 AS `employee_position_department`,
 1 AS `period_start_date`,
 1 AS `period_end_date`,
 1 AS `monthly_rate`,
 1 AS `daily_rate`,
 1 AS `days_worked`,
 1 AS `overtime_hours`,
 1 AS `gross_income`,
 1 AS `rice_subsidy`,
 1 AS `phone_allowance`,
 1 AS `clothing_allowance`,
 1 AS `total_benefits`,
 1 AS `social_security_system`,
 1 AS `philhealth`,
 1 AS `pagibig`,
 1 AS `withholding_tax`,
 1 AS `total_deductions`,
 1 AS `summary_gross_income`,
 1 AS `summary_benefits`,
 1 AS `summary_deductions`,
 1 AS `take_home_pay`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `withholding_tax_bracket`
--

DROP TABLE IF EXISTS `withholding_tax_bracket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `withholding_tax_bracket` (
  `bracket_id` int NOT NULL AUTO_INCREMENT,
  `min_salary` decimal(12,2) NOT NULL,
  `max_salary` decimal(12,2) DEFAULT NULL,
  `base_tax` decimal(12,2) NOT NULL DEFAULT '0.00',
  `excess_rate` decimal(5,4) NOT NULL,
  `effective_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`bracket_id`),
  UNIQUE KEY `uq_withholding_bracket` (`min_salary`,`max_salary`,`effective_date`),
  CONSTRAINT `chk_base_tax` CHECK ((`base_tax` >= 0)),
  CONSTRAINT `chk_excess_rate` CHECK ((`excess_rate` >= 0)),
  CONSTRAINT `chk_min_salary` CHECK ((`min_salary` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `vw_employee_payslip`
--

/*!50001 DROP VIEW IF EXISTS `vw_employee_payslip`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`aoop_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_employee_payslip` AS with `payroll_base` as (select `e`.`employee_pk` AS `employee_pk`,`e`.`employee_no` AS `employee_id`,concat(`e`.`last_name`,', ',`e`.`first_name`) AS `employee_name`,concat(`jp`.`position_name`,' / ',`d`.`department_name`) AS `employee_position_department`,min(`ar`.`attendance_date`) AS `period_start_date`,max(`ar`.`attendance_date`) AS `period_end_date`,`ep`.`basic_salary` AS `monthly_rate`,round((`ep`.`basic_salary` / 20),2) AS `daily_rate`,count(distinct `ar`.`attendance_date`) AS `days_worked`,0 AS `overtime_hours`,round(((`ep`.`basic_salary` / 20) * count(distinct `ar`.`attendance_date`)),2) AS `gross_income`,coalesce(`es`.`rice_subsidy`,0) AS `rice_subsidy`,coalesce(`es`.`phone_allowance`,0) AS `phone_allowance`,coalesce(`es`.`clothing_allowance`,0) AS `clothing_allowance`,((coalesce(`es`.`rice_subsidy`,0) + coalesce(`es`.`phone_allowance`,0)) + coalesce(`es`.`clothing_allowance`,0)) AS `total_benefits`,900 AS `social_security_system`,450 AS `philhealth`,100 AS `pagibig` from (((((`employee` `e` join `employee_position` `ep` on((`e`.`employee_pk` = `ep`.`employee_pk`))) join `job_position` `jp` on((`ep`.`position_id` = `jp`.`position_id`))) join `department` `d` on((`ep`.`department_id` = `d`.`department_id`))) left join `attendance_record` `ar` on((`e`.`employee_pk` = `ar`.`employee_pk`))) left join `employee_staging` `es` on((`es`.`employee_no` = `e`.`employee_no`))) group by `e`.`employee_pk`,`e`.`employee_no`,`e`.`first_name`,`e`.`last_name`,`jp`.`position_name`,`d`.`department_name`,`ep`.`basic_salary`,`es`.`rice_subsidy`,`es`.`phone_allowance`,`es`.`clothing_allowance`), `tax_computation` as (select `p`.`employee_pk` AS `employee_pk`,`p`.`employee_id` AS `employee_id`,`p`.`employee_name` AS `employee_name`,`p`.`employee_position_department` AS `employee_position_department`,`p`.`period_start_date` AS `period_start_date`,`p`.`period_end_date` AS `period_end_date`,`p`.`monthly_rate` AS `monthly_rate`,`p`.`daily_rate` AS `daily_rate`,`p`.`days_worked` AS `days_worked`,`p`.`overtime_hours` AS `overtime_hours`,`p`.`gross_income` AS `gross_income`,`p`.`rice_subsidy` AS `rice_subsidy`,`p`.`phone_allowance` AS `phone_allowance`,`p`.`clothing_allowance` AS `clothing_allowance`,`p`.`total_benefits` AS `total_benefits`,`p`.`social_security_system` AS `social_security_system`,`p`.`philhealth` AS `philhealth`,`p`.`pagibig` AS `pagibig`,((`p`.`gross_income` + `p`.`total_benefits`) - ((`p`.`social_security_system` + `p`.`philhealth`) + `p`.`pagibig`)) AS `taxable_income` from `payroll_base` `p`), `final_payroll` as (select `t`.`employee_pk` AS `employee_pk`,`t`.`employee_id` AS `employee_id`,`t`.`employee_name` AS `employee_name`,`t`.`employee_position_department` AS `employee_position_department`,`t`.`period_start_date` AS `period_start_date`,`t`.`period_end_date` AS `period_end_date`,`t`.`monthly_rate` AS `monthly_rate`,`t`.`daily_rate` AS `daily_rate`,`t`.`days_worked` AS `days_worked`,`t`.`overtime_hours` AS `overtime_hours`,`t`.`gross_income` AS `gross_income`,`t`.`rice_subsidy` AS `rice_subsidy`,`t`.`phone_allowance` AS `phone_allowance`,`t`.`clothing_allowance` AS `clothing_allowance`,`t`.`total_benefits` AS `total_benefits`,`t`.`social_security_system` AS `social_security_system`,`t`.`philhealth` AS `philhealth`,`t`.`pagibig` AS `pagibig`,`t`.`taxable_income` AS `taxable_income`,round(coalesce(((`wtb`.`base_tax` / 2) + ((`t`.`taxable_income` - (`wtb`.`min_salary` / 2)) * `wtb`.`excess_rate`)),0),2) AS `withholding_tax` from (`tax_computation` `t` left join `withholding_tax_bracket` `wtb` on(((`t`.`taxable_income` >= (`wtb`.`min_salary` / 2)) and ((`t`.`taxable_income` < (`wtb`.`max_salary` / 2)) or (`wtb`.`max_salary` is null)))))) select `final_payroll`.`employee_id` AS `employee_id`,`final_payroll`.`employee_name` AS `employee_name`,`final_payroll`.`employee_position_department` AS `employee_position_department`,`final_payroll`.`period_start_date` AS `period_start_date`,`final_payroll`.`period_end_date` AS `period_end_date`,`final_payroll`.`monthly_rate` AS `monthly_rate`,`final_payroll`.`daily_rate` AS `daily_rate`,`final_payroll`.`days_worked` AS `days_worked`,`final_payroll`.`overtime_hours` AS `overtime_hours`,`final_payroll`.`gross_income` AS `gross_income`,`final_payroll`.`rice_subsidy` AS `rice_subsidy`,`final_payroll`.`phone_allowance` AS `phone_allowance`,`final_payroll`.`clothing_allowance` AS `clothing_allowance`,`final_payroll`.`total_benefits` AS `total_benefits`,`final_payroll`.`social_security_system` AS `social_security_system`,`final_payroll`.`philhealth` AS `philhealth`,`final_payroll`.`pagibig` AS `pagibig`,`final_payroll`.`withholding_tax` AS `withholding_tax`,(((`final_payroll`.`social_security_system` + `final_payroll`.`philhealth`) + `final_payroll`.`pagibig`) + `final_payroll`.`withholding_tax`) AS `total_deductions`,`final_payroll`.`gross_income` AS `summary_gross_income`,`final_payroll`.`total_benefits` AS `summary_benefits`,(((`final_payroll`.`social_security_system` + `final_payroll`.`philhealth`) + `final_payroll`.`pagibig`) + `final_payroll`.`withholding_tax`) AS `summary_deductions`,((`final_payroll`.`gross_income` + `final_payroll`.`total_benefits`) - (((`final_payroll`.`social_security_system` + `final_payroll`.`philhealth`) + `final_payroll`.`pagibig`) + `final_payroll`.`withholding_tax`)) AS `take_home_pay` from `final_payroll` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-21 10:44:39
