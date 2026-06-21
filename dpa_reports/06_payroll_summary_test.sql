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

-- =========================================
-- 1. MONTHLY - ALL EMPLOYEES
-- =========================================
CALL sp_payroll_summary('MONTHLY', '2024-12-01', NULL);

-- =========================================
-- 2. SEMI-MONTHLY FIRST HALF
-- =========================================
CALL sp_payroll_summary('SEMI_MONTHLY', '2024-12-10', NULL);

-- =========================================
-- 3. SEMI-MONTHLY SECOND HALF
-- =========================================
CALL sp_payroll_summary('SEMI_MONTHLY', '2024-12-20', NULL);

-- =========================================
-- 4. SINGLE EMPLOYEE CHECK
-- =========================================
CALL sp_payroll_summary('MONTHLY', '2024-12-01', '10015');

-- =========================================
-- 5. MONTHLY - SELECTED EMPLOYEES (ORDERED OUTPUT FIX)
--    NOTE: procedure supports only single filter,
--    so we simulate batch calls
-- =========================================
CALL sp_payroll_summary(
    'MONTHLY',
    '2024-12-01',
    '10015,10005,10022,10034,10003'
);