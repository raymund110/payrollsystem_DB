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

DROP VIEW IF EXISTS vw_payroll_summary;

CREATE OR REPLACE VIEW vw_payroll_summary AS

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

    net_pay

FROM vw_payroll_core;