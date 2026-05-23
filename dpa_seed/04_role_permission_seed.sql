-- =========================================
-- Module: Role Permission Mapping
-- File: 03_role_permission_seed.sql
-- =========================================

USE payrollsystem_db;

-- ADMIN (ALL ACCESS)
INSERT INTO role_permission (role_id, permission_id)
SELECT 1, permission_id FROM permission;

-- HR
INSERT INTO role_permission (role_id, permission_id)
SELECT 2, permission_id
FROM permission
WHERE permission_name IN (
    'VIEW_EMPLOYEES',
    'EDIT_EMPLOYEES',
    'APPROVE_LEAVE'
);

-- PAYROLL
INSERT INTO role_permission (role_id, permission_id)
SELECT 3, permission_id
FROM permission
WHERE permission_name IN (
    'VIEW_PAYROLL',
    'GENERATE_PAYROLL'
);

-- EMPLOYEE (SELF SERVICE ONLY)
INSERT INTO role_permission (role_id, permission_id)
SELECT 4, permission_id
FROM permission
WHERE permission_name = 'VIEW_SELF';