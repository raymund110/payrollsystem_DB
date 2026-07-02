-- =========================================
-- Module: Employee Payslip Reporting
-- File: 01_employee_payslip_view.sql
--
-- Description:
-- Generates a semi-monthly employee payslip for MotorPH.
--
-- Payroll Assumptions:
-- 1. Monthly salary uses 22 working days divisor.
-- 2. Rank-and-file employees use attendance-based payroll.
-- 3. Chiefs / Management use fixed semi-monthly payroll.
-- 4. Benefits are split equally per cutoff.
-- 5. Statutory deductions use monthly salary basis.
-- 6. Monthly deductions are allocated semi-monthly.
-- 7. All benefits are treated as taxable compensation.
-- =========================================

USE payrollsystem_db;

DROP VIEW IF EXISTS vw_employee_payslip;

CREATE OR REPLACE VIEW vw_employee_payslip AS

WITH
    payroll_period AS (
        SELECT
            period_name,
            period_start,
            period_end
        FROM payroll_period_config
        WHERE
            period_type = 'PAYSLIP'
            AND is_active = TRUE
        LIMIT 1
    ),
    attendance_filtered AS (
        SELECT ar.employee_pk, ar.attendance_date, ar.hours_worked
        FROM
            attendance_record ar
            JOIN payroll_period p ON ar.attendance_date BETWEEN p.period_start AND p.period_end
    ),
    payroll_base AS (
        SELECT
            e.employee_pk,
            e.employee_no AS employee_id,
            CONCAT(
                e.last_name,
                ', ',
                e.first_name
            ) AS employee_name,
            d.department_name,
            jp.position_name,
            p.period_name,
            p.period_start,
            p.period_end,
            ep.basic_salary AS monthly_rate,
            ROUND(ep.basic_salary / 22, 2) AS daily_rate,
            COUNT(DISTINCT a.attendance_date) AS days_worked,
            COALESCE(SUM(a.hours_worked), 0) AS total_hours_worked
        FROM
            employee e
            CROSS JOIN payroll_period p
            JOIN employee_position ep ON e.employee_pk = ep.employee_pk
            AND ep.end_date IS NULL
            JOIN job_position jp ON ep.position_id = jp.position_id
            JOIN department d ON ep.department_id = d.department_id
            LEFT JOIN attendance_filtered a ON e.employee_pk = a.employee_pk
        GROUP BY
            e.employee_pk,
            e.employee_no,
            e.last_name,
            e.first_name,
            d.department_name,
            jp.position_name,
            ep.basic_salary,
            p.period_name,
            p.period_start,
            p.period_end
    ),
    calc AS (
        SELECT
            b.*,
            CASE
                WHEN b.position_name IN (
                    'Chief',
                    'Manager',
                    'Management'
                ) THEN ROUND(b.monthly_rate / 2, 2)
                ELSE ROUND(
                    b.daily_rate * b.days_worked,
                    2
                )
            END AS gross_income,
            ROUND(
                COALESCE(es.rice_subsidy, 0) / 2,
                2
            ) AS rice_subsidy,
            ROUND(
                COALESCE(es.phone_allowance, 0) / 2,
                2
            ) AS phone_allowance,
            ROUND(
                COALESCE(es.clothing_allowance, 0) / 2,
                2
            ) AS clothing_allowance,
            ROUND(
                COALESCE(es.rice_subsidy, 0) + COALESCE(es.phone_allowance, 0) + COALESCE(es.clothing_allowance, 0),
                2
            ) AS monthly_benefits,
            ROUND(
                (
                    COALESCE(es.rice_subsidy, 0) + COALESCE(es.phone_allowance, 0) + COALESCE(es.clothing_allowance, 0)
                ) / 2,
                2
            ) AS total_benefits,
            ROUND(
                COALESCE(
                    (
                        SELECT contribution / 2
                        FROM sss_contribution_bracket s
                        WHERE
                            b.monthly_rate >= s.min_compensation
                            AND b.monthly_rate < s.max_compensation
                        LIMIT 1
                    ),
                    0
                ),
                2
            ) AS sss,
            ROUND(
                COALESCE(
                    (
                        SELECT ROUND(
                                (
                                    LEAST(
                                        GREATEST(
                                            b.monthly_rate, r.floor_amount
                                        ), r.ceiling_amount
                                    ) * r.premium_rate * r.employee_share_rate
                                ) / 2, 2
                            )
                        FROM philhealth_contribution_rule r
                        WHERE
                            r.rule_id = 1
                    ),
                    0
                ),
                2
            ) AS philhealth,
            ROUND(
                CASE
                    WHEN b.monthly_rate <= 1500 THEN LEAST(
                        LEAST(b.monthly_rate, 10000) * 0.01,
                        100
                    ) / 2
                    ELSE LEAST(
                        LEAST(b.monthly_rate, 10000) * 0.02,
                        200
                    ) / 2
                END,
                2
            ) AS pagibig
        FROM
            payroll_base b
            LEFT JOIN employee_staging es ON es.employee_no = b.employee_id
    ),
    tax AS (
        SELECT c.*, ROUND(
                c.monthly_rate + c.monthly_benefits - (
                    (
                        c.sss + c.philhealth + c.pagibig
                    ) * 2
                ), 2
            ) AS monthly_taxable_income
        FROM calc c
    ),
    final AS (
        SELECT t.*, ROUND(
                COALESCE(
                    (
                        SELECT (
                                w.base_tax + (
                                    (
                                        t.monthly_taxable_income - w.min_salary
                                    ) * w.excess_rate
                                )
                            ) / 2
                        FROM withholding_tax_bracket w
                        WHERE
                            t.monthly_taxable_income >= w.min_salary
                            AND (
                                t.monthly_taxable_income <= w.max_salary
                                OR w.max_salary IS NULL
                            )
                        ORDER BY w.min_salary DESC
                        LIMIT 1
                    ), 0
                ), 2
            ) AS withholding_tax
        FROM tax t
    )
SELECT
    f.*,
    psi.payslip_no,
    ROUND(
        sss + philhealth + pagibig + withholding_tax,
        2
    ) AS total_deductions,
    ROUND(
        (gross_income + total_benefits) - (
            sss + philhealth + pagibig + withholding_tax
        ),
        2
    ) AS take_home_pay
FROM
    final f
    LEFT JOIN employee_payslip_identity psi ON psi.employee_pk = f.employee_pk
    AND psi.period_start = f.period_start;