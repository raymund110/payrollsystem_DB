-- =========================================
-- Module: Payroll Summary Reporting
-- File: 04_payroll_core_view.sql
-- Description:
-- Core monthly payroll computation for Dec 2024
-- =========================================

USE payrollsystem_db;

DROP VIEW IF EXISTS vw_payroll_core;

CREATE OR REPLACE VIEW vw_payroll_core AS

WITH payroll_period AS (
    SELECT
        '2024-12-01' AS period_start,
        '2024-12-31' AS period_end
),

attendance_filtered AS (
    SELECT
        ar.employee_pk,
        ar.attendance_date
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

        ep.basic_salary AS monthly_rate

    FROM employee e
    JOIN employee_position ep
        ON e.employee_pk = ep.employee_pk
    JOIN job_position jp
        ON ep.position_id = jp.position_id
    JOIN department d
        ON ep.department_id = d.department_id

    WHERE EXISTS (
        SELECT 1
        FROM attendance_filtered a
        WHERE a.employee_pk = e.employee_pk
    )
),

calc AS (
    SELECT
        b.*,

        ROUND(b.monthly_rate, 2) AS gross_income,

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

        ROUND(COALESCE((
            SELECT contribution
            FROM sss_contribution_bracket s
            WHERE c.gross_income BETWEEN s.min_compensation AND s.max_compensation
            LIMIT 1
        ),0),2) AS sss_contribution,

        ROUND(COALESCE((
            SELECT c.gross_income * r.premium_rate * r.employee_share
            FROM philhealth_contribution_rule r
            WHERE c.gross_income BETWEEN r.min_salary AND r.max_salary
            LIMIT 1
        ),0),2) AS philhealth_contribution,

        ROUND(COALESCE((
            SELECT LEAST(c.gross_income * r.employee_rate, r.max_contribution)
            FROM pagibig_contribution_rule r
            WHERE c.gross_income BETWEEN r.min_salary AND r.max_salary
            LIMIT 1
        ),0),2) AS pagibig_contribution

    FROM calc c
),

tax_calc AS (
    SELECT
        d.*,

        ROUND(
            gross_income + total_benefits
            - (sss_contribution + philhealth_contribution + pagibig_contribution),
            2
        ) AS taxable_income

    FROM deductions d
)

SELECT
    t.*,

    ROUND(COALESCE((
        SELECT
            w.base_tax +
            ((t.taxable_income - w.min_salary) * w.excess_rate)
        FROM withholding_tax_bracket w
        WHERE t.taxable_income >= w.min_salary
          AND (t.taxable_income <= w.max_salary OR w.max_salary IS NULL)
        ORDER BY w.min_salary DESC
        LIMIT 1
    ),0),2) AS withholding_tax,

    ROUND(
        (
            gross_income + total_benefits
        ) -
        (
            sss_contribution
            + philhealth_contribution
            + pagibig_contribution
            + COALESCE((
                SELECT
                    w.base_tax +
                    ((t.taxable_income - w.min_salary) * w.excess_rate)
                FROM withholding_tax_bracket w
                WHERE t.taxable_income >= w.min_salary
                  AND (t.taxable_income <= w.max_salary OR w.max_salary IS NULL)
                ORDER BY w.min_salary DESC
                LIMIT 1
            ),0)
        ),
        2
    ) AS net_pay

FROM tax_calc t;