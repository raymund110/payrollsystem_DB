-- =========================================
-- Module: Department Seed Data
-- File: 00_department_seed.sql
-- Description:
--     Inserts default departments required for ETL processing
-- =========================================

USE payrollsystem_db;

INSERT INTO department (department_name, description)
SELECT 'General', 'Default department for ETL employee assignment'
WHERE NOT EXISTS (
    SELECT 1 FROM department WHERE department_name = 'General'
);