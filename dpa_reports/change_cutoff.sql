-- =========================================
-- Update Active Payslip Period
-- Used by Employee Payslip Reporting
-- =========================================

USE payrollsystem_db;

UPDATE payroll_period_config
SET
    period_name  = 'November 2024 Second Cutoff',
    period_start = '2024-11-16',
    period_end   = '2024-11-30'
WHERE period_type = 'PAYSLIP'
  AND is_active = TRUE;

-- Run to generate Payslip Number
INSERT INTO employee_payslip_identity (
    employee_pk,
    period_start,
    period_end,
    payslip_no
)
SELECT
    e.employee_pk,
    p.period_start,
    p.period_end,
    CONCAT(
        RIGHT(e.employee_no, 2),
        '-',
        DATE_FORMAT(p.period_start, '%Y-%m-%d')
    )
FROM employee e
CROSS JOIN payroll_period_config p
WHERE p.period_type = 'PAYSLIP'
  AND p.is_active = TRUE

ON DUPLICATE KEY UPDATE
    period_end = VALUES(period_end);
