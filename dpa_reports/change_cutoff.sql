-- =========================================
-- Update Active Payslip Period
-- Used by Employee Payslip Reporting
-- =========================================

UPDATE payroll_period_config
SET
    period_name  = 'November 2024 Second Cutoff',
    period_start = '2024-11-16',
    period_end   = '2024-11-30'
WHERE period_type = 'PAYSLIP'
  AND is_active = TRUE;
