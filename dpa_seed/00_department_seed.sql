-- =========================================
-- Module: Department Seed Data
-- File: 00_department_seed.sql
-- Description:
--     Inserts default departments required for ETL processing
-- =========================================

USE payrollsystem_db;

INSERT INTO department (department_name, description)
VALUES
('IT', 'IT Department'),
('HR', 'HR Department'),
('Finance', 'Finance Department'),
('Accounting', 'Accounting Department'),
('Sales', 'Marketing Department'),
('Operations', 'Operations and Customer Service Department'),
('Leadership', 'Executive Management'),
('General', 'Default fallback department for unmapped roles')

ON DUPLICATE KEY UPDATE
description = VALUES(description);