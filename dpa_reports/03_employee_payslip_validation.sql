SELECT
    employee_id,
    employee_name,
    gross_income,
    total_benefits,
    sss,
    philhealth,
    pagibig,
    withholding_tax,
    total_deductions,
    take_home_pay
FROM vw_employee_payslip
WHERE employee_id = '10015';