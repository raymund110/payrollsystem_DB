-- =========================================
-- Module: Payroll Summary Validation Reporting
-- File: 09_payroll_summary_validation_summary.sql
-- Description:
-- Validates payroll summary computations for all employees in the active payroll period
-- =========================================

USE payrollsystem_db;

SELECT
    'DUPLICATE EMPLOYEE CHECK' AS `TEST`,
    'Ensures one payroll row per employee per period' AS `DESCRIPTION`,
    COUNT(*) AS `DUPLICATES FOUND`,
    0 AS `EXPECTED`,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS `RESULT`
FROM (
    SELECT employee_no
    FROM vw_payroll_summary
    GROUP BY employee_no
    HAVING COUNT(*) > 1
) x;


SELECT
    'PAYROLL TOTALS CHECK' AS `TEST`,
    'Displays payroll totals for reporting validation' AS `DESCRIPTION`,
    ROUND(SUM(gross_income),2) AS gross_total,
    ROUND(SUM(net_pay),2) AS net_total
FROM vw_payroll_summary;