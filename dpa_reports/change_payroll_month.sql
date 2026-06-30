-- =========================================
-- Update Active Payroll Period
-- Used by Payroll Summary Reporting December 2024
-- =========================================

UPDATE payroll_period_config
SET
    period_name  = 'December 2024 Monthly Payroll',
    period_start = '2024-12-01',
    period_end   = '2024-12-31'
WHERE period_type = 'PAYROLL'
  AND is_active = TRUE;