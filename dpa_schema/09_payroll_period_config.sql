-- =========================================
-- Module: Payroll Period Config
-- File: 09_payroll_period_config.sql
-- Description:
-- Stores active payroll periods used by:
-- - Employee Payslip Reporting (bi-monthly)
-- - Payroll Summary Reporting (monthly)
-- =========================================

USE payrollsystem_db;

DROP TABLE IF EXISTS payroll_period_config;

CREATE TABLE payroll_period_config (
    config_id INT AUTO_INCREMENT PRIMARY KEY,

    period_type ENUM('PAYSLIP', 'PAYROLL') NOT NULL,

    period_name VARCHAR(100) NOT NULL,

    period_start DATE NOT NULL,
    period_end DATE NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO payroll_period_config (
    period_type,
    period_name,
    period_start,
    period_end,
    is_active
)
VALUES

(
    'PAYSLIP',
    'December 2024 First Cutoff',
    '2024-12-01',
    '2024-12-15',
    TRUE
),

(
    'PAYROLL',
    'December 2024 Monthly Payroll',
    '2024-12-01',
    '2024-12-31',
    TRUE
);