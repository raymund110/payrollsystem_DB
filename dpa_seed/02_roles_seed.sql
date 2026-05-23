-- =========================================
-- Module: Roles Seed
-- File: 06_roles_seed.sql
-- =========================================

USE payrollsystem_db;

INSERT INTO role (role_name) VALUES
('ADMIN'),
('HR'),
('PAYROLL'),
('FINANCE'),
('EMPLOYEE'),
('IT');