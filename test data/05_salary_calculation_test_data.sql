USE payrollsystem_db;

-- Testing Salary Calculation relationships

-- insert departments
INSERT INTO department (dept_name, description)
VALUES
    ('Administration', 'Handles overall company operations'),
    ('Human Resources', 'Handles employee management'),
    ('Payroll', 'Handles salary processing'),
    ('Operations', 'Handles daily company operations');

-- insert positions
INSERT INTO position (position_name)
VALUES
    ('Admin'),
    ('HR Manager'),
    ('Payroll Officer'),
    ('Employee');

-- insert allowance types
INSERT INTO allowance_type (name)
VALUES
    ('Rice Subsidy'),
    ('Phone Allowance'),
    ('Clothing Allowance');

-- insert employee positions
INSERT INTO employee_position (
    employee_id,
    position_id,
    effective_date,
    dept_id,
    basic_salary,
    end_date
) VALUES
    ('E001', 1, '2026-01-01', 1, 60000.00, NULL),
    ('E002', 2, '2026-01-01', 2, 45000.00, NULL),
    ('E003', 4, '2026-01-01', 4, 30000.00, NULL),
    ('E004', 3, '2026-01-01', 3, 40000.00, NULL),
    ('E005', 4, '2026-01-01', 4, 30000.00, NULL);

-- insert position allowances
INSERT INTO position_allowance (
    position_id,
    allowance_type_id,
    amount
) VALUES
    (1, 1, 5000.00),
    (2, 2, 3000.00),
    (3, 3, 2500.00),
    (4, 1, 1500.00);