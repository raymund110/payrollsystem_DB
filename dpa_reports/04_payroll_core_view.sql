-- =========================================
-- Module: Payroll Core View
-- File: 04_payroll_core_view.sql
-- Description:
-- Reusable employee payroll “base dataset”
-- CONTAINS:
--   employee
--   position
--   department
--   benefits
--   identifiers (SSS, TIN, etc.)
-- =========================================

USE payrollsystem_db;

DROP VIEW IF EXISTS vw_payroll_core;

CREATE VIEW vw_payroll_core AS
SELECT
    e.employee_pk,
    e.employee_no,
    CONCAT(e.last_name, ', ', e.first_name) AS employee_full_name,

    jp.position_name,

    CASE
        WHEN jp.position_name LIKE 'IT%' THEN 'IT'
        WHEN jp.position_name LIKE 'HR%' THEN 'HR'
        WHEN jp.position_name LIKE 'Payroll%' THEN 'Finance'
        WHEN jp.position_name LIKE 'Finance%' THEN 'Finance'
        WHEN jp.position_name LIKE 'Accounting%' THEN 'Accounting'
        WHEN jp.position_name LIKE 'Chief%' THEN 'Leadership'
        WHEN jp.position_name LIKE 'Customer%' THEN 'Operations'
        WHEN jp.position_name LIKE 'Sales%' THEN 'Marketing'
        WHEN jp.position_name LIKE 'Supply%' THEN 'Operations'
        ELSE 'Operations'
    END AS department_name,

    e.sss_number,
    e.philhealth_number,
    e.tin_number,
    e.pagibig_number,

    ep.basic_salary,

    ep.basic_salary / 160 AS hourly_rate

FROM employee e
JOIN employee_position ep ON e.employee_pk = ep.employee_pk
JOIN job_position jp ON ep.position_id = jp.position_id;