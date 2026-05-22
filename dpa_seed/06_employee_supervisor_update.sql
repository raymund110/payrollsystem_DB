-- =========================================
-- Module: Supervisor Resolution
-- File: 03_employee_supervisor_update.sql
-- Description:
--     Resolves supervisor names → employee_id
-- =========================================

USE payrollsystem_db;

UPDATE employee e
JOIN employee_staging s
    ON e.employee_no = s.employee_no
JOIN employee sup
    ON CONCAT(sup.last_name, ', ', sup.first_name) = s.supervisor_name
SET e.supervisor_employee_pk = sup.employee_pk;