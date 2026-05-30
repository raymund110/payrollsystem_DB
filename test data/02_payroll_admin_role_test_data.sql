USE payrollsystem_db;

-- Testing Payroll Admin Role relationships

-- insert payroll earning types
INSERT INTO payroll_earning_type (name, taxable)
VALUES
    ('Basic Pay', 1),
    ('Bonus', 1);

-- insert payroll deduction types
INSERT INTO payroll_deduction_type (name, government_mandated)
VALUES
    ('SSS', 1),
    ('PhilHealth', 1);

-- insert withholding tax bracket
INSERT INTO withholding_tax_bracket (min_salary, max_salary, tax_rate, effective_date)
VALUES
    (30000.00, 60000.00, 0.15, '2026-01-01');

-- insert payroll records for all employees
INSERT INTO payroll (employee_id, pay_period_start, gross_pay, total_deductions, net_pay, pay_period_end)
VALUES
    ('E001', '2026-05-01', 50000.00, 5000.00, 45000.00, '2026-05-15'),
    ('E002', '2026-05-01', 42000.00, 4200.00, 37800.00, '2026-05-15'),
    ('E003', '2026-05-01', 30000.00, 3000.00, 27000.00, '2026-05-15'),
    ('E004', '2026-05-01', 38000.00, 3800.00, 34200.00, '2026-05-15'),
    ('E005', '2026-05-01', 35000.00, 3500.00, 31500.00, '2026-05-15');

-- insert payroll earnings for all employees
INSERT INTO payroll_earning (earning_type_id, payroll_id, amount)
VALUES
    (1, 1, 50000.00),
    (1, 2, 42000.00),
    (1, 3, 30000.00),
    (1, 4, 38000.00),
    (1, 5, 35000.00);

-- insert payroll deductions for all employees
INSERT INTO payroll_deduction (bracket_id, deduction_type_id, payroll_id, amount)
VALUES
    (1, 1, 1, 5000.00),
    (1, 1, 2, 4200.00),
    (1, 1, 3, 3000.00),
    (1, 1, 4, 3800.00),
    (1, 1, 5, 3500.00);