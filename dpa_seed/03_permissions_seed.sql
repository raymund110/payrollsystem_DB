-- =========================================
-- Module: Permissions Seed
-- File: 07_permissions_seed.sql
-- =========================================

USE payrollsystem_db;

INSERT INTO permission (permission_name) VALUES
('VIEW_EMPLOYEES'),
('EDIT_EMPLOYEES'),
('APPROVE_LEAVE'),
('VIEW_PAYROLL'),
('GENERATE_PAYROLL'),
('MANAGE_USERS'),
('VIEW_SELF');