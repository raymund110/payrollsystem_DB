-- =========================================
-- Module: Payroll Summary Procedure
-- File: 05_payroll_summary_procedure.sql
-- Description:
-- Main requirement: Generate payroll summary report (report engine)
-- for a specified pay period.
-- CONTAINS:
--   IN start_date
--   IN end_date
--   IN employee_no (optional)
--   attendance filtering
--   payroll computation
--   tax computation
--   net pay
--   grouping logic
-- =========================================

USE payrollsystem_db;

DROP PROCEDURE IF EXISTS sp_payroll_summary;

DELIMITER $$

CREATE PROCEDURE sp_payroll_summary (
    IN p_period_type VARCHAR(20),
    IN p_ref_date DATE,
    IN p_employee_list TEXT
)
BEGIN

DECLARE v_start_date DATE;
DECLARE v_end_date DATE;

-- =========================================
-- PERIOD ENGINE
-- =========================================
IF p_period_type = 'MONTHLY' THEN
    SET v_start_date = DATE_FORMAT(p_ref_date, '%Y-%m-01');
    SET v_end_date   = LAST_DAY(p_ref_date);

ELSEIF p_period_type = 'SEMI_MONTHLY' THEN

    IF DAY(p_ref_date) <= 15 THEN
        SET v_start_date = DATE_FORMAT(p_ref_date, '%Y-%m-01');
        SET v_end_date   = DATE_FORMAT(p_ref_date, '%Y-%m-15');
    ELSE
        SET v_start_date = DATE_FORMAT(p_ref_date, '%Y-%m-16');
        SET v_end_date   = LAST_DAY(p_ref_date);
    END IF;

END IF;

-- =========================================
-- ATTENDANCE BASE
-- =========================================
WITH attendance_summary AS (
    SELECT
        employee_pk,
        SUM(hours_worked) AS total_hours_worked,
        COUNT(DISTINCT attendance_date) AS days_worked
    FROM attendance_record
    WHERE attendance_date BETWEEN v_start_date AND v_end_date
    GROUP BY employee_pk
),

-- =========================================
-- PAYROLL BASE
-- =========================================
payroll_base AS (
    SELECT
        c.employee_pk,
        c.employee_no,
        c.employee_full_name,
        c.position_name,
        c.department_name,
        c.sss_number,
        c.philhealth_number,
        c.tin_number,
        c.pagibig_number,
        c.basic_salary,
        c.hourly_rate,

        COALESCE(a.total_hours_worked, 0) AS total_hours_worked,
        COALESCE(a.days_worked, 0) AS days_worked,

        ROUND(c.hourly_rate * COALESCE(a.total_hours_worked, 0), 2) AS gross_income
    FROM vw_payroll_core c
    LEFT JOIN attendance_summary a
        ON a.employee_pk = c.employee_pk
),

-- =========================================
-- SSS (TABLE)
-- =========================================
sss_calc AS (
    SELECT p.*,
        s.contribution AS sss_contribution
    FROM payroll_base p
    LEFT JOIN sss_contribution_bracket s
        ON p.gross_income >= s.min_compensation
        AND p.gross_income < s.max_compensation
),

-- =========================================
-- PHILHEALTH
-- =========================================
philhealth_calc AS (
    SELECT s.*,
        ROUND((s.gross_income * pcr.premium_rate) * pcr.employee_share, 2)
        AS philhealth_contribution
    FROM sss_calc s
    LEFT JOIN philhealth_contribution_rule pcr
        ON s.gross_income BETWEEN pcr.min_salary AND pcr.max_salary
),

-- =========================================
-- PAGIBIG
-- =========================================
pagibig_calc AS (
    SELECT ph.*,
        LEAST(ph.gross_income * pic.employee_rate, pic.max_contribution)
        AS pagibig_contribution
    FROM philhealth_calc ph
    LEFT JOIN pagibig_contribution_rule pic
        ON ph.gross_income BETWEEN pic.min_salary AND pic.max_salary
),

-- =========================================
-- TAXABLE
-- =========================================
tax_calc AS (
    SELECT *,
        (gross_income - (sss_contribution + philhealth_contribution + pagibig_contribution))
        AS taxable_income
    FROM pagibig_calc
),

-- =========================================
-- FINAL TAX
-- =========================================
final_calc AS (
    SELECT t.*,
        wtb.base_tax,
        wtb.excess_rate,
        wtb.min_salary,
        wtb.max_salary,

        ROUND(
            COALESCE(
                (wtb.base_tax / 2) +
                ((t.taxable_income - (wtb.min_salary / 2)) * wtb.excess_rate),
                0
            ),
            2
        ) AS withholding_tax
    FROM tax_calc t
    LEFT JOIN withholding_tax_bracket wtb
        ON t.taxable_income >= (wtb.min_salary / 2)
        AND (t.taxable_income < (wtb.max_salary / 2) OR wtb.max_salary IS NULL)
),

-- =========================================
-- FILTER + ORDER
-- =========================================
ordered AS (
    SELECT *
    FROM final_calc
    WHERE
        p_employee_list IS NULL
        OR FIND_IN_SET(employee_no, p_employee_list)
)

-- =========================================
-- FINAL REPORT OUTPUT
-- =========================================
SELECT
    employee_no AS `Employee No`,
    employee_full_name AS `Employee Full Name`,
    position_name AS `Position`,
    department_name AS `Department`,
    v_start_date AS `Period Start`,
    v_end_date AS `Period End`,
    total_hours_worked,
    days_worked,
    ROUND(gross_income,2) AS gross_income,

    sss_number AS `SSS No`,
    sss_contribution AS `SSS`,

    philhealth_number AS `PhilHealth No`,
    philhealth_contribution AS `PhilHealth`,

    pagibig_number AS `PagIBIG No`,
    pagibig_contribution AS `PagIBIG`,

    tin_number AS `TIN`,
    withholding_tax AS `BIR`,

    (sss_contribution + philhealth_contribution + pagibig_contribution + withholding_tax)
        AS total_deductions,

    (gross_income - (sss_contribution + philhealth_contribution + pagibig_contribution + withholding_tax))
        AS net_pay

FROM ordered

-- preserve order EXACTLY like input list
ORDER BY FIND_IN_SET(employee_no, p_employee_list);

END$$

DELIMITER ;