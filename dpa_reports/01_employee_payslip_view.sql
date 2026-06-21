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

/* =========================
   FIXED PAYROLL PERIOD
   ========================= */
WITH payroll_period AS (
    SELECT
        '2024-06-16' AS period_start,
        '2024-06-30' AS period_end
),

/* =========================
   FILTER ATTENDANCE
   ========================= */
attendance_filtered AS (
    SELECT
        ar.employee_pk,
        ar.attendance_date,
        ar.hours_worked
    FROM attendance_record ar
    JOIN payroll_period p
        ON ar.attendance_date BETWEEN p.period_start AND p.period_end
),

/* =========================
   BASE PAYROLL DATA
   ========================= */
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

        ROUND(ep.basic_salary / 20, 2) AS daily_rate,

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

/* =========================
   COMPUTATIONS
   ========================= */
calc AS (
    SELECT
        b.*,

        /* SAMPLE-ALIGNED GROSS PAY */
        ROUND(b.daily_rate * b.days_worked, 2) AS gross_income,

        /* BENEFITS (SOURCE OF TRUTH: employee_staging) */
        COALESCE(es.rice_subsidy, 0) AS rice_subsidy,
        COALESCE(es.phone_allowance, 0) AS phone_allowance,
        COALESCE(es.clothing_allowance, 0) AS clothing_allowance,

        (
            COALESCE(es.rice_subsidy, 0)
            + COALESCE(es.phone_allowance, 0)
            + COALESCE(es.clothing_allowance, 0)
        ) AS total_benefits,

        /* =========================
           STATUTORY (TABLE-DRIVEN)
           ========================= */

        COALESCE((
            SELECT contribution
            FROM sss_contribution_bracket s
            WHERE b.daily_rate * b.days_worked
                  BETWEEN s.min_compensation AND s.max_compensation
            LIMIT 1
        ), 0) AS sss,

        COALESCE((
            SELECT ROUND((b.daily_rate * b.days_worked) * r.premium_rate * r.employee_share, 2)
            FROM philhealth_contribution_rule r
            WHERE (b.daily_rate * b.days_worked)
                  BETWEEN r.min_salary AND r.max_salary
            LIMIT 1
        ), 0) AS philhealth,

        COALESCE((
            SELECT LEAST((b.daily_rate * b.days_worked) * r.employee_rate, r.max_contribution)
            FROM pagibig_contribution_rule r
            WHERE (b.daily_rate * b.days_worked)
                  BETWEEN r.min_salary AND r.max_salary
            LIMIT 1
        ), 0) AS pagibig

    FROM payroll_base b
    LEFT JOIN employee_staging es
        ON es.employee_no = b.employee_id
),

/* =========================
   TAXABLE INCOME
   ========================= */
tax AS (
    SELECT
        c.*,
        (
            gross_income
            + total_benefits
            - (sss + philhealth + pagibig)
        ) AS taxable_income
    FROM calc c
),

/* =========================
   WITHHOLDING TAX
   ========================= */
final AS (
    SELECT
        t.*,

        COALESCE((
            SELECT
                w.base_tax +
                ((t.taxable_income - w.min_salary) * w.excess_rate)
            FROM withholding_tax_bracket w
            WHERE t.taxable_income >= w.min_salary
              AND (t.taxable_income <= w.max_salary OR w.max_salary IS NULL)
            ORDER BY w.min_salary DESC
            LIMIT 1
        ), 0) AS withholding_tax

    FROM tax t
)

/* =========================
   OUTPUT
   ========================= */
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

    (sss + philhealth + pagibig + withholding_tax) AS total_deductions,

    (gross_income + total_benefits)
    - (sss + philhealth + pagibig + withholding_tax) AS take_home_pay

FROM final;