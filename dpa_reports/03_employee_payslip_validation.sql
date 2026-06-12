-- =========================================
-- Module: Employee Payslip Validation
-- File: 03_employee_payslip_validation.sql
-- Description:
-- Validates payroll calculations
-- for reporting accuracy.
-- =========================================

USE payrollsystem_db;

-- =========================================
-- VALIDATE GROSS INCOME
-- =========================================

SELECT
    employee_id,
    employee_name,
    monthly_rate,
    daily_rate,
    days_worked,
    gross_income
FROM vw_employee_payslip
ORDER BY employee_id;

-- =========================================
-- VALIDATE BENEFITS
-- =========================================

SELECT
    employee_id,
    employee_name,
    rice_subsidy,
    phone_allowance,
    clothing_allowance,
    total_benefits
FROM vw_employee_payslip
ORDER BY employee_id;

-- =========================================
-- VALIDATE DEDUCTIONS
-- =========================================

SELECT
    employee_id,
    employee_name,
    sss_deduction,
    philhealth_deduction,
    pagibig_deduction,
    withholding_tax,
    total_deductions
FROM vw_employee_payslip
ORDER BY employee_id;

-- =========================================
-- VALIDATE TAKE HOME PAY
-- =========================================

SELECT
    employee_id,
    employee_name,
    gross_income,
    total_benefits,
    total_deductions,
    take_home_pay
FROM vw_employee_payslip
ORDER BY employee_id;

-- =========================================
-- END OF FILE
-- =========================================