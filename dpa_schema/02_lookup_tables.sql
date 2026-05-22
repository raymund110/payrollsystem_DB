-- =========================================
-- Module: Lookup Tables
-- File: 02_lookup_tables.sql
-- Description:
--     Contains reusable lookup/reference tables
-- =========================================

USE payrollsystem_db;

-- Employment Status
CREATE TABLE employment_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(30) NOT NULL UNIQUE
);

-- Leave Status
CREATE TABLE leave_status (
    leave_status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(30) NOT NULL UNIQUE
);

-- Leave Type
CREATE TABLE leave_type (
    leave_type_id INT PRIMARY KEY AUTO_INCREMENT,
    leave_name VARCHAR(50) NOT NULL UNIQUE,
    is_paid TINYINT(1) NOT NULL DEFAULT 1,
    max_days_per_year INT NOT NULL,
    CHECK (max_days_per_year >= 0)
);

-- Overtime Type
CREATE TABLE overtime_type (
    overtime_type_id INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(50) NOT NULL UNIQUE,
    rate_multiplier DECIMAL(4,2) NOT NULL,
    CHECK (rate_multiplier > 0)
);

-- Payroll Deduction Type
CREATE TABLE payroll_deduction_type (
    deduction_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    government_mandated TINYINT(1) NOT NULL DEFAULT 1
);

-- Payroll Earning Type
CREATE TABLE payroll_earning_type (
    earning_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    taxable TINYINT(1) NOT NULL DEFAULT 1
);

-- Allowance Type
CREATE TABLE allowance_type (
    allowance_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- =========================================
-- PAYROLL STATUS
-- =========================================
CREATE TABLE payroll_status (
    payroll_status_id INT PRIMARY KEY AUTO_INCREMENT,

    status_name VARCHAR(30)
        NOT NULL UNIQUE
);