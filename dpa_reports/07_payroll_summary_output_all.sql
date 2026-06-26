-- =========================================
-- Module: Payroll Summary Output Reporting
-- File: 07_payroll_summary_output_all.sql
-- Description:
-- Generates a payroll summary report for all employees in the active payroll period
-- =========================================

USE payrollsystem_db;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT
    employee_no AS `Employee No`,
    employee_name AS `Employee Full Name`,
    position_name AS `Position`,
    department_name AS `Department`,
    gross_income AS `Gross Income`,
    sss_number AS `Social Security No.`,
    sss_contribution AS `Social Security Contribution`,
    philhealth_number AS `Philhealth No.`,
    philhealth_contribution AS `Philhealth Contribution`,
    pagibig_number AS `Pag-ibig No.`,
    pagibig_contribution AS `Pag-Ibig Contribution`,
    tin_number AS `TIN`,
    withholding_tax AS `Withholding Tax`,
    net_pay AS `Net Pay`
FROM (
    SELECT
        employee_no,
        employee_name,
        position_name,
        department_name,
        gross_income,
        sss_number,
        sss_contribution,
        philhealth_number,
        philhealth_contribution,
        pagibig_number,
        pagibig_contribution,
        tin_number,
        withholding_tax,
        net_pay,
        0 AS sort_order,
        employee_no AS emp_order
    FROM vw_payroll_summary

    UNION ALL

    SELECT
        'TOTAL',
        '',
        '',
        '',
        ROUND(SUM(gross_income), 2),
        '',
        ROUND(SUM(sss_contribution), 2),
        '',
        ROUND(SUM(philhealth_contribution), 2),
        '',
        ROUND(SUM(pagibig_contribution), 2),
        '',
        ROUND(SUM(withholding_tax), 2),
        ROUND(SUM(net_pay), 2),
        1,
        999999
    FROM vw_payroll_summary
) AS payroll_data
ORDER BY
    sort_order,
    emp_order;