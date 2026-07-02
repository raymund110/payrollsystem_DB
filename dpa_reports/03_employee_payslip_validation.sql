-- Combined Validation Report for Employee 10005

SELECT
    v.employee_id AS `EMPLOYEE ID`,
    p.period_name AS `PAYROLL CUTOFF`,
    p.period_start AS `PERIOD START`,
    p.period_end AS `PERIOD END`,
    'TOTAL DEDUCTIONS' AS `TEST`,
    'Verifies sum of SSS, PhilHealth, PagIBIG, and Tax equals total deductions' AS `DESCRIPTION`,
    v.total_deductions AS `ACTUAL`,
    ROUND(v.sss + v.philhealth + v.pagibig + v.withholding_tax, 2) AS `EXPECTED`,
    CASE
        WHEN v.total_deductions = ROUND(v.sss + v.philhealth + v.pagibig + v.withholding_tax, 2)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS `RESULT`
FROM vw_employee_payslip v
JOIN payroll_period_config p ON p.period_type = 'PAYSLIP' AND p.is_active = TRUE
WHERE v.employee_id = '10005'

UNION ALL

SELECT
    v.employee_id,
    p.period_name,
    p.period_start,
    p.period_end,
    'TAKE HOME PAY',
    'Verifies Gross + Benefits - Deductions equals Take Home Pay',
    v.take_home_pay,
    ROUND((v.gross_income + v.total_benefits) - v.total_deductions, 2),
    CASE
        WHEN v.take_home_pay = ROUND((v.gross_income + v.total_benefits) - v.total_deductions, 2)
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM vw_employee_payslip v
JOIN payroll_period_config p ON p.period_type = 'PAYSLIP' AND p.is_active = TRUE
WHERE v.employee_id = '10005'

UNION ALL

SELECT
    v.employee_id,
    p.period_name,
    p.period_start,
    p.period_end,
    'GROSS INCOME',
    'Verifies Daily Rate multiplied by Days Worked equals Gross Income',
    v.gross_income,
    ROUND(v.daily_rate * v.days_worked, 2),
    CASE
        WHEN v.gross_income = ROUND(v.daily_rate * v.days_worked, 2)
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM vw_employee_payslip v
JOIN payroll_period_config p ON p.period_type = 'PAYSLIP' AND p.is_active = TRUE
WHERE v.employee_id = '10005';