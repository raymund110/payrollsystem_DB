-- =========================================
-- Module: Employee Payslip Reporting
-- File: 01_employee_payslip_view.sql
-- Description:
-- Creates employee payslip reporting
-- view using bi-monthly payroll cutoff.
-- =========================================

USE payrollsystem_db;

DROP VIEW IF EXISTS vw_employee_payslip;

CREATE VIEW vw_employee_payslip AS
SELECT
    CONCAT(
        e.employee_no,
        '-',
        YEAR(MAX(ar.attendance_date)),
        '-',
        DATE_FORMAT(MAX(ar.attendance_date), '%m-%d')
    ) AS payslip_no,

    e.employee_no AS employee_id,

    CONCAT(
        e.last_name,
        ', ',
        e.first_name
    ) AS employee_name,

    CONCAT(
        jp.position_name,
        ' / ',
        d.department_name
    ) AS employee_position_department,

    MIN(ar.attendance_date) AS period_start_date,
    MAX(ar.attendance_date) AS period_end_date,

    ep.basic_salary AS monthly_rate,

    ROUND(ep.basic_salary / 20, 2)
        AS daily_rate,

    COUNT(ar.attendance_id)
        AS days_worked,

    0 AS overtime_hours,

    ROUND(
        (ep.basic_salary / 20)
        * COUNT(ar.attendance_id),
        2
    ) AS gross_income,

    COALESCE(es.rice_subsidy, 0)
        AS rice_subsidy,

    COALESCE(es.phone_allowance, 0)
        AS phone_allowance,

    COALESCE(es.clothing_allowance, 0)
        AS clothing_allowance,

    (
        COALESCE(es.rice_subsidy, 0)
        + COALESCE(es.phone_allowance, 0)
        + COALESCE(es.clothing_allowance, 0)
    ) AS total_benefits,

    900 AS sss_deduction,
    450 AS philhealth_deduction,
    100 AS pagibig_deduction,
    0 AS withholding_tax,

    (
        900
        + 450
        + 100
    ) AS total_deductions,

    (
        ROUND(
            (ep.basic_salary / 20)
            * COUNT(ar.attendance_id),
            2
        )
        +
        (
            COALESCE(es.rice_subsidy, 0)
            + COALESCE(es.phone_allowance, 0)
            + COALESCE(es.clothing_allowance, 0)
        )
        -
        (
            900
            + 450
            + 100
        )
    ) AS take_home_pay

FROM employee e

JOIN employee_position ep
    ON e.employee_pk = ep.employee_pk

JOIN job_position jp
    ON ep.position_id = jp.position_id

JOIN department d
    ON ep.department_id = d.department_id

JOIN attendance_record ar
    ON e.employee_pk = ar.employee_pk

LEFT JOIN employee_staging es
    ON es.employee_no = e.employee_no

WHERE ar.attendance_date
BETWEEN '2024-12-16'
AND '2024-12-31'

GROUP BY
    e.employee_pk,
    e.employee_no,
    e.first_name,
    e.last_name,
    jp.position_name,
    d.department_name,
    ep.basic_salary,
    es.rice_subsidy,
    es.phone_allowance,
    es.clothing_allowance;