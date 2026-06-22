-- =========================================
-- Module: Payroll Summary Procedure
-- File: 06_payroll_summary_test.sql
-- Description:
-- Test script for sp_payroll_summary procedure
-- CONTAINS:
--   monthly run
--   bi-monthly run
--   single employee run
--   all employees run
-- =========================================

USE payrollsystem_db;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT *
FROM vw_payroll_summary;

SELECT
    ROUND(SUM(gross_income), 2) AS total_gross_income,
    ROUND(SUM(sss_contribution), 2) AS total_sss,
    ROUND(SUM(philhealth_contribution), 2) AS total_philhealth,
    ROUND(SUM(pagibig_contribution), 2) AS total_pagibig,
    ROUND(SUM(withholding_tax), 2) AS total_withholding_tax,
    ROUND(SUM(net_pay), 2) AS total_net_pay
FROM vw_payroll_summary;