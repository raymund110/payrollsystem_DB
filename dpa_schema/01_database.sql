-- =========================================
-- Module: Database Initialization
-- File: 01_database.sql
-- Description:
--     Creates the payroll system database
-- Verify: select databse();  or \s
-- =========================================

CREATE DATABASE IF NOT EXISTS payrollsystem_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE payrollsystem_db;