USE payrollsystem_db;

-- Check employee user roles
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    ua.username,
    r.role_name
FROM employee e
JOIN user_account ua
    ON e.employee_id = ua.employee_id
JOIN role r
    ON ua.role_id = r.role_id;


-- Check attendance records
SELECT
    e.employee_id,
    e.first_name,
    a.work_date,
    a.hours_worked
FROM employee e
JOIN attendance a
    ON e.employee_id = a.employee_id;


-- Check overtime records
SELECT
    e.employee_id,
    e.first_name,
    oe.work_date,
    oe.hours,
    ot.description,
    ot.rate_multiplier
FROM employee e
JOIN overtime_entry oe
    ON e.employee_id = oe.employee_id
JOIN overtime_type ot
    ON oe.overtime_type_id = ot.overtime_type_id;


-- Check leave requests
SELECT
    e.employee_id,
    e.first_name,
    lt.leave_name,
    lr.start_date,
    lr.end_date,
    lr.status
FROM employee e
JOIN leave_request lr
    ON e.employee_id = lr.employee_id
JOIN leave_type lt
    ON lr.leave_type_id = lt.leave_type_id;


-- Check employee positions and departments
SELECT
    e.employee_id,
    e.first_name,
    p.position_name,
    d.dept_name,
    ep.basic_salary
FROM employee e
JOIN employee_position ep
    ON e.employee_id = ep.employee_id
JOIN position p
    ON ep.position_id = p.position_id
JOIN department d
    ON ep.dept_id = d.dept_id;


-- Check position allowances
SELECT
    p.position_name,
    at.name AS allowance_name,
    pa.amount
FROM position p
JOIN position_allowance pa
    ON p.position_id = pa.position_id
JOIN allowance_type at
    ON pa.allowance_type_id = at.allowance_type_id;


-- Check payroll records
SELECT
    e.employee_id,
    e.first_name,
    p.payroll_id,
    p.gross_pay,
    p.total_deductions,
    p.net_pay
FROM employee e
JOIN payroll p
    ON e.employee_id = p.employee_id;


-- Check payroll earnings
SELECT
    p.payroll_id,
    pet.name AS earning_type,
    pe.amount
FROM payroll p
JOIN payroll_earning pe
    ON p.payroll_id = pe.payroll_id
JOIN payroll_earning_type pet
    ON pe.earning_type_id = pet.earning_type_id;


-- Check payroll deductions
SELECT
    p.payroll_id,
    pdt.name AS deduction_type,
    pd.amount,
    wtb.tax_rate
FROM payroll p
JOIN payroll_deduction pd
    ON p.payroll_id = pd.payroll_id
JOIN payroll_deduction_type pdt
    ON pd.deduction_type_id = pdt.deduction_type_id
JOIN withholding_tax_bracket wtb
    ON pd.bracket_id = wtb.bracket_id;