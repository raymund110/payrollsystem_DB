-- =========================================
-- Module: Employee Payslip Reporting
-- File: 01_employee_payslip_view.sql
-- Description:
-- This view generates a semi-monthly employee payslip report using employee master data, position details, attendance records, and statutory deductions.
-- It computes gross pay, benefits, taxable income, withholding tax, and take-home pay per employee.
-- =========================================

USE payrollsystem_db;

DROP VIEW IF EXISTS vw_employee_payslip;

CREATE VIEW vw_employee_payslip AS

WITH payroll_base AS (

    SELECT
        e.employee_pk,
        e.employee_no AS employee_id,

        CONCAT(e.last_name, ', ', e.first_name) AS employee_name,

        CONCAT(jp.position_name, ' / ', d.department_name)
            AS employee_position_department,

        MIN(ar.attendance_date) AS period_start_date,
        MAX(ar.attendance_date) AS period_end_date,

        ep.basic_salary AS monthly_rate,

        ROUND(ep.basic_salary / 20, 2) AS daily_rate,

        COUNT(DISTINCT ar.attendance_date) AS days_worked,

        0 AS overtime_hours,

        ROUND(
            (ep.basic_salary / 20) * COUNT(DISTINCT ar.attendance_date),
            2
        ) AS gross_income,

        COALESCE(es.rice_subsidy, 0) AS rice_subsidy,
        COALESCE(es.phone_allowance, 0) AS phone_allowance,
        COALESCE(es.clothing_allowance, 0) AS clothing_allowance,

        (
            COALESCE(es.rice_subsidy, 0)
            + COALESCE(es.phone_allowance, 0)
            + COALESCE(es.clothing_allowance, 0)
        ) AS total_benefits,

        900 AS social_security_system,
        450 AS philhealth,
        100 AS pagibig

    FROM employee e

    JOIN employee_position ep
        ON e.employee_pk = ep.employee_pk

    JOIN job_position jp
        ON ep.position_id = jp.position_id

    JOIN department d
        ON ep.department_id = d.department_id

    LEFT JOIN attendance_record ar
        ON e.employee_pk = ar.employee_pk   

    LEFT JOIN employee_staging es
        ON es.employee_no = e.employee_no

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
        es.clothing_allowance
),

tax_computation AS (

    SELECT
        p.*,
        (
            p.gross_income
            + p.total_benefits
            - (p.social_security_system + p.philhealth + p.pagibig)
        ) AS taxable_income

    FROM payroll_base p
),

final_payroll AS (

    SELECT
        t.*,

        ROUND(
            COALESCE(
                (wtb.base_tax / 2)
                +
                (
                    (t.taxable_income - (wtb.min_salary / 2))
                    * wtb.excess_rate
                ),
                0
            ),
            2
        ) AS withholding_tax

    FROM tax_computation t

    LEFT JOIN withholding_tax_bracket wtb
        ON t.taxable_income >= (wtb.min_salary / 2)
        AND (
            t.taxable_income < (wtb.max_salary / 2)
            OR wtb.max_salary IS NULL
        )
)

SELECT
    employee_id,
    employee_name,
    employee_position_department,
    period_start_date,
    period_end_date,
    monthly_rate,
    daily_rate,
    days_worked,
    overtime_hours,
    gross_income,
    rice_subsidy,
    phone_allowance,
    clothing_allowance,
    total_benefits,
    social_security_system,
    philhealth,
    pagibig,
    withholding_tax,

    (social_security_system + philhealth + pagibig + withholding_tax)
        AS total_deductions,

    gross_income AS summary_gross_income,
    total_benefits AS summary_benefits,

    (social_security_system + philhealth + pagibig + withholding_tax)
        AS summary_deductions,

    (
        gross_income + total_benefits
        - (social_security_system + philhealth + pagibig + withholding_tax)
    ) AS take_home_pay

FROM final_payroll;