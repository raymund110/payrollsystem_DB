-- =========================================
-- Module: Employee Payslip Reporting (FINAL)
-- File: 01_employee_payslip_view.sql
-- Description:
-- Generates a bi-monthly employee payslip using:
-- - Employee master data
-- - Position + department tables
-- - Attendance records
-- - Employee allowances (staging)
-- - Table-driven statutory deductions
-- - Course-based withholding tax brackets
-- =========================================

USE payrollsystem_db;

DROP VIEW IF EXISTS vw_employee_payslip;

CREATE OR REPLACE VIEW vw_employee_payslip AS

WITH payroll_period AS (
    SELECT
        '2024-12-01' AS period_start,
        '2024-12-15' AS period_end
),

attendance_filtered AS (
    SELECT
        ar.employee_pk,
        ar.attendance_date,
        ar.hours_worked
    FROM attendance_record ar
    JOIN payroll_period p
        ON ar.attendance_date BETWEEN p.period_start AND p.period_end
),

payroll_base AS (
    SELECT
        e.employee_pk,
        e.employee_no AS employee_id,
        CONCAT(e.last_name, ', ', e.first_name) AS employee_name,

        d.department_name,
        jp.position_name,

        p.period_start,
        p.period_end,

        ep.basic_salary AS monthly_rate,
        ROUND(ep.basic_salary / 22, 2) AS daily_rate,

        COUNT(DISTINCT a.attendance_date) AS days_worked,
        COALESCE(SUM(a.hours_worked), 0) AS total_hours_worked

    FROM employee e
    CROSS JOIN payroll_period p

    JOIN employee_position ep
        ON e.employee_pk = ep.employee_pk
    JOIN job_position jp
        ON ep.position_id = jp.position_id
    JOIN department d
        ON ep.department_id = d.department_id

    LEFT JOIN attendance_filtered a
        ON e.employee_pk = a.employee_pk

    GROUP BY
        e.employee_pk,
        e.employee_no,
        e.last_name,
        e.first_name,
        d.department_name,
        jp.position_name,
        ep.basic_salary,
        p.period_start,
        p.period_end
),

calc AS (
    SELECT
        b.*,

        ROUND(b.daily_rate * b.days_worked, 2) AS gross_income,

        ROUND(COALESCE(es.rice_subsidy, 0) / 2, 2) AS rice_subsidy,
        ROUND(COALESCE(es.phone_allowance, 0) / 2, 2) AS phone_allowance,
        ROUND(COALESCE(es.clothing_allowance, 0) / 2, 2) AS clothing_allowance,

        ROUND(
            ROUND(COALESCE(es.rice_subsidy, 0) / 2, 2)
            + ROUND(COALESCE(es.phone_allowance, 0) / 2, 2)
            + ROUND(COALESCE(es.clothing_allowance, 0) / 2, 2),
            2
        ) AS total_benefits,

        ROUND(COALESCE((
            SELECT contribution
            FROM sss_contribution_bracket s
            WHERE (b.daily_rate * b.days_worked)
                  BETWEEN s.min_compensation AND s.max_compensation
            LIMIT 1
        ), 0), 2) AS sss,

        ROUND(COALESCE((
            SELECT ROUND(
                (b.daily_rate * b.days_worked)
                * r.premium_rate
                * r.employee_share,
                2
            )
            FROM philhealth_contribution_rule r
            WHERE (b.daily_rate * b.days_worked)
                  BETWEEN r.min_salary AND r.max_salary
            LIMIT 1
        ), 0), 2) AS philhealth,

        ROUND(COALESCE((
            SELECT LEAST(
                (b.daily_rate * b.days_worked) * r.employee_rate,
                r.max_contribution
            )
            FROM pagibig_contribution_rule r
            WHERE (b.daily_rate * b.days_worked)
                  BETWEEN r.min_salary AND r.max_salary
            LIMIT 1
        ), 0), 2) AS pagibig

    FROM payroll_base b
    LEFT JOIN employee_staging es
        ON es.employee_no = b.employee_id
),

tax AS (
    SELECT
        c.*,
        ROUND(
            gross_income
            + total_benefits
            - (sss + philhealth + pagibig),
            2
        ) AS taxable_income
    FROM calc c
),

final AS (
    SELECT
        t.*,

        ROUND(COALESCE((
            SELECT
                w.base_tax +
                ((t.taxable_income - w.min_salary) * w.excess_rate)
            FROM withholding_tax_bracket w
            WHERE t.taxable_income >= w.min_salary
              AND (
                  t.taxable_income <= w.max_salary
                  OR w.max_salary IS NULL
              )
            ORDER BY w.min_salary DESC
            LIMIT 1
        ), 0), 2) AS withholding_tax

    FROM tax t
)

SELECT
    employee_id,
    employee_name,
    department_name,
    position_name,

    period_start,
    period_end,

    monthly_rate,
    daily_rate,

    days_worked,
    total_hours_worked,

    gross_income,

    rice_subsidy,
    phone_allowance,
    clothing_allowance,
    total_benefits,

    sss,
    philhealth,
    pagibig,

    taxable_income,
    withholding_tax,

    ROUND(
        sss + philhealth + pagibig + withholding_tax,
        2
    ) AS total_deductions,

    ROUND(
        (gross_income + total_benefits)
        - (sss + philhealth + pagibig + withholding_tax),
        2
    ) AS take_home_pay

FROM final;