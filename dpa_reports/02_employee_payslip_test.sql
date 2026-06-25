SELECT
    employee_id AS `EMPLOYEE ID`,
    employee_name AS `EMPLOYEE NAME`,
    department_name AS `DEPARTMENT`,
    position_name AS `POSITION`,
    period_start AS `PERIOD START DATE`,
    period_end AS `PERIOD END DATE`,

    monthly_rate AS `MONTHLY RATE`,
    daily_rate AS `DAILY RATE`,
    days_worked AS `DAYS WORKED`,
    total_hours_worked AS `TOTAL HOURS WORKED`,

    gross_income AS `GROSS INCOME`,

    rice_subsidy AS `RICE SUBSIDY`,
    phone_allowance AS `PHONE ALLOWANCE`,
    clothing_allowance AS `CLOTHING ALLOWANCE`,
    total_benefits AS `TOTAL BENEFITS`,

    sss AS `SSS CONTRIBUTION`,
    philhealth AS `PHILHEALTH CONTRIBUTION`,
    pagibig AS `PAG-IBIG CONTRIBUTION`,
    withholding_tax AS `WITHHOLDING TAX`,

    total_deductions AS `TOTAL DEDUCTIONS`,
    take_home_pay AS `TAKE HOME PAY`
FROM vw_employee_payslip
WHERE employee_id = '10005';