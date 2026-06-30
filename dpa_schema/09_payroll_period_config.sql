-- =========================================
-- Module: Payroll Period Configuration
-- File: 09_payroll_period_config.sql
--
-- Description:
-- Stores the active payroll period configuration
-- used by payroll-related reports.
--
-- Supported Modules:
-- - Employee Payslip Reporting (bi-monthly)
-- - Payroll Summary Reporting (monthly)
--
-- Business Rules:
-- - Only one active PAYSLIP period should exist.
-- - Only one active PAYROLL period should exist.
-- - Reports automatically read the active period.
-- - Updating this table changes report periods
--   without modifying SQL views or procedures.
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
    'November 2024 First Cutoff',
    '2024-11-01',
    '2024-11-15',
    TRUE
),
(
    'PAYROLL',
    'November 2024 Monthly Payroll',
    '2024-11-01',
    '2024-11-30',
    TRUE
);