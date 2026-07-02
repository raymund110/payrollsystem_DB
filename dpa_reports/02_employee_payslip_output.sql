USE payrollsystem_db;
-- Payslip Report Specific to Employee ID 10005
SELECT
    payslip_no AS `PAYSLIP NO`,
    employee_id AS `EMPLOYEE ID`,
    employee_name AS `EMPLOYEE NAME`,
    CONCAT(position_name, ' / ', department_name) AS `EMPLOYEE POSITION/DEPARTMENT`,

    period_name AS `PAYROLL PERIOD`,
    period_start AS `PERIOD START DATE`,
    period_end AS `PERIOD END DATE`,

    monthly_rate AS `Monthly Salary`,
    daily_rate AS `Daily Rate`,
    days_worked AS `Days Worked`,
    total_hours_worked AS `Total Hours Worked`,

    gross_income AS `GROSS INCOME`,

    rice_subsidy AS `Rice Subsidy`,
    phone_allowance AS `Phone Allowance`,
    clothing_allowance AS `Clothing Allowance`,
    total_benefits AS `TOTAL BENEFITS`,

    sss AS `Social Security System`,
    philhealth AS `PhilHealth`,
    pagibig AS `Pag-IBIG`,
    withholding_tax AS `Withholding Tax`,

    total_deductions AS `TOTAL DEDUCTIONS`,
    take_home_pay AS `TAKE HOME PAY`

FROM vw_employee_payslip
WHERE employee_id = '10005';


-- Payslip Report for All Employees (After Cutoff Update)
SELECT
    payslip_no AS `PAYSLIP NO`,
    employee_id AS `EMPLOYEE ID`,
    employee_name AS `EMPLOYEE NAME`,
    CONCAT(position_name, ' / ', department_name) AS `EMPLOYEE POSITION/DEPARTMENT`,

    period_name AS `PAYROLL PERIOD`,
    period_start AS `PERIOD START DATE`,
    period_end AS `PERIOD END DATE`,

    monthly_rate AS `Monthly Salary`,
    daily_rate AS `Daily Rate`,
    days_worked AS `Days Worked`,
    total_hours_worked AS `Total Hours Worked`,

    gross_income AS `GROSS INCOME`,

    rice_subsidy AS `Rice Subsidy`,
    phone_allowance AS `Phone Allowance`,
    clothing_allowance AS `Clothing Allowance`,
    total_benefits AS `TOTAL BENEFITS`,

    sss AS `Social Security System`,
    philhealth AS `PhilHealth`,
    pagibig AS `Pag-IBIG`,
    withholding_tax AS `Withholding Tax`,

    total_deductions AS `TOTAL DEDUCTIONS`,
    take_home_pay AS `TAKE HOME PAY`
FROM vw_employee_payslip;
