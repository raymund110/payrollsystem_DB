-- =========================================
-- Module: Payroll Summary Reporting
-- File: 04_payroll_core_view.sql
--
-- Description:
-- Core monthly payroll computation for all employees.
--
-- Payroll Model:
-- MotorPH has mixed employee types:
-- - Regular employees
-- - Probationary employees
-- - Rank and File
-- - Chiefs
-- - Management
--
-- Payroll Assumptions:
-- 1. Payroll summary is monthly.
-- 2. Monthly salary uses 22 working days divisor.
-- 3. Rank-and-file employees use attendance-based payroll.
-- 4. Chiefs / Management use fixed monthly payroll.
-- 5. Benefits are monthly.
-- 6. Statutory deductions use monthly salary basis.
-- 7. All benefits are treated as taxable compensation.
-- =========================================

USE payrollsystem_db;

DROP VIEW IF EXISTS vw_payroll_core;

CREATE OR REPLACE VIEW vw_payroll_core AS

WITH payroll_period AS (
    SELECT
        period_start,
        period_end
    FROM payroll_period_config
    WHERE period_type = 'PAYROLL'
      AND is_active = TRUE
    LIMIT 1
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
        e.employee_no,

        CONCAT(e.last_name, ', ', e.first_name) AS employee_name,

        e.sss_number,
        e.philhealth_number,
        e.pagibig_number,
        e.tin_number,

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
     AND ep.end_date IS NULL

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
        e.sss_number,
        e.philhealth_number,
        e.pagibig_number,
        e.tin_number,
        d.department_name,
        jp.position_name,
        p.period_start,
        p.period_end,
        ep.basic_salary
),

calc AS (
    SELECT
        b.*,

        -- Gross Income (Hybrid Workforce Model)
        CASE
            WHEN b.position_name IN ('Chief', 'Manager', 'Management')
                THEN ROUND(b.monthly_rate, 2)
            ELSE ROUND(b.daily_rate * b.days_worked, 2)
        END AS gross_income,

        ROUND(COALESCE(es.rice_subsidy, 0), 2) AS rice_subsidy,
        ROUND(COALESCE(es.phone_allowance, 0), 2) AS phone_allowance,
        ROUND(COALESCE(es.clothing_allowance, 0), 2) AS clothing_allowance,

        ROUND(
            COALESCE(es.rice_subsidy, 0)
            + COALESCE(es.phone_allowance, 0)
            + COALESCE(es.clothing_allowance, 0),
            2
        ) AS total_benefits

    FROM payroll_base b
    LEFT JOIN employee_staging es
      ON es.employee_no = b.employee_no
),

deductions AS (
    SELECT
        c.*,

        -- SSS
        ROUND(
            COALESCE(
                (
                    SELECT contribution
                    FROM sss_contribution_bracket s
                    WHERE c.monthly_rate >= s.min_compensation
                      AND c.monthly_rate < s.max_compensation
                    LIMIT 1
                ),
                0
            ),
            2
        ) AS sss_contribution,

        -- PhilHealth
        ROUND(
            COALESCE(
                (
                    SELECT ROUND(
                        LEAST(
                            GREATEST(c.monthly_rate, r.floor_amount),
                            r.ceiling_amount
                        ) * r.premium_rate * r.employee_share_rate,
                        2
                    )
                    FROM philhealth_contribution_rule r
                    WHERE r.rule_id = 1
                ),
                0
            ),
            2
        ) AS philhealth_contribution,

        -- Pag-IBIG
        ROUND(
            CASE
                WHEN c.monthly_rate <= 1500 THEN
                    LEAST(
                        LEAST(c.monthly_rate, 10000) * 0.01,
                        100
                    )
                ELSE
                    LEAST(
                        LEAST(c.monthly_rate, 10000) * 0.02,
                        200
                    )
            END,
            2
        ) AS pagibig_contribution

    FROM calc c
),

tax_calc AS (
    SELECT
        d.*,

        ROUND(
            d.monthly_rate
            + d.total_benefits
            - (
                d.sss_contribution
                + d.philhealth_contribution
                + d.pagibig_contribution
            ),
            2
        ) AS taxable_income

    FROM deductions d
),

final_tax AS (
    SELECT
        t.*,

        ROUND(
            COALESCE(
                (
                    SELECT
                        w.base_tax +
                        (
                            (t.taxable_income - w.min_salary)
                            * w.excess_rate
                        )
                    FROM withholding_tax_bracket w
                    WHERE t.taxable_income >= w.min_salary
                      AND (
                            t.taxable_income <= w.max_salary
                            OR w.max_salary IS NULL
                      )
                    ORDER BY w.min_salary DESC
                    LIMIT 1
                ),
                0
            ),
            2
        ) AS withholding_tax

    FROM tax_calc t
)

SELECT
    employee_pk,
    employee_no,
    employee_name,

    sss_number,
    philhealth_number,
    pagibig_number,
    tin_number,

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

    sss_contribution,
    philhealth_contribution,
    pagibig_contribution,

    taxable_income,
    withholding_tax,

    ROUND(
        sss_contribution
        + philhealth_contribution
        + pagibig_contribution
        + withholding_tax,
        2
    ) AS total_deductions,

    ROUND(
        (gross_income + total_benefits)
        -
        (
            sss_contribution
            + philhealth_contribution
            + pagibig_contribution
            + withholding_tax
        ),
        2
    ) AS net_pay

FROM final_tax;