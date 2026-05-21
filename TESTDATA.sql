-- PAYROLL SYSTEM DATABASE - TEST DATA

-- 1. INSERT DEPARTMENTS
INSERT INTO department (dept_name, description) VALUES
('Human Resources', 'HR Department'),
('Finance', 'Finance and Accounting'),
('Operations', 'Operations and Management'),
('IT', 'Information Technology');

-- 2. INSERT POSITIONS
INSERT INTO position (position_name) VALUES
('Manager'),
('Senior Developer'),
('Junior Developer'),
('HR Specialist'),
('Finance Officer');

-- 3. INSERT ALLOWANCE TYPES
INSERT INTO allowance_type (name) VALUES
('Hazard Pay'),
('Night Differential'),
('Meal Allowance'),
('Transportation Allowance');

-- 4. INSERT POSITION-ALLOWANCE MAPPINGS
INSERT INTO position_allowance (position_id, allowance_type_id, amount) VALUES
(1, 1, 5000),      -- Manager gets Hazard Pay (5000)
(1, 3, 3000),      -- Manager gets Meal Allowance (3000)
(2, 2, 2000),      -- Senior Dev gets Night Differential (2000)
(2, 4, 1500),      -- Senior Dev gets Transportation (1500)
(3, 2, 1500),      -- Junior Dev gets Night Differential (1500)
(4, 3, 2000),      -- HR Specialist gets Meal Allowance (2000)
(5, 1, 3000);      -- Finance Officer gets Hazard Pay (3000)

-- 5. INSERT EMPLOYEES
INSERT INTO employee (employee_id, first_name, last_name, birthday, address, phone_number, 
                      sss_number, philhealth_number, tin_number, pagibig_number, status, supervisor_id) VALUES
('E001', 'Juan', 'Dela Cruz', '1985-05-15', '123 Main St', '09171234567', 'SSS001', 'PH001', 'TIN001', 'PAG001', 'REGULAR', NULL),
('E002', 'Maria', 'Santos', '1990-08-20', '456 Oak Ave', '09171234568', 'SSS002', 'PH002', 'TIN002', 'PAG002', 'REGULAR', 'E001'),
('E003', 'Pedro', 'Reyes', '1992-03-10', '789 Pine St', '09171234569', 'SSS003', 'PH003', 'TIN003', 'PAG003', 'PROBATIONARY', 'E001'),
('E004', 'Ana', 'Garcia', '1988-12-25', '321 Elm Dr', '09171234570', 'SSS004', 'PH004', 'TIN004', 'PAG004', 'REGULAR', 'E001'),
('E005', 'Miguel', 'Lopez', '1995-07-30', '654 Birch Ln', '09171234571', 'SSS005', 'PH005', 'TIN005', 'PAG005', 'REGULAR', 'E002');

-- 6. INSERT USER ACCOUNTS (1:1 relationship test)
INSERT INTO user_account (username, password_hash, role, employee_id, is_active) VALUES
('juan_admin', 'hashed_pwd_001', 'ADMIN', 'E001', 1),
('maria_hr', 'hashed_pwd_002', 'HR', 'E002', 1),
('pedro_dev', 'hashed_pwd_003', 'EMPLOYEE', 'E003', 1),
('ana_payroll', 'hashed_pwd_004', 'PAYROLL', 'E004', 1),
('miguel_emp', 'hashed_pwd_005', 'EMPLOYEE', 'E005', 1);

-- 7. INSERT EMPLOYEE POSITIONS (Composite PK test)
INSERT INTO employee_position (employee_id, position_id, effective_date, dept_id, basic_salary, end_date) VALUES
('E001', 1, '2020-01-15', 3, 75000.00, NULL),           -- E001 = Manager in Operations
('E002', 4, '2021-06-01', 1, 55000.00, NULL),           -- E002 = HR Specialist in HR
('E003', 3, '2022-08-15', 4, 35000.00, NULL),           -- E003 = Junior Dev in IT
('E004', 5, '2021-03-10', 2, 60000.00, NULL),           -- E004 = Finance Officer in Finance
('E005', 2, '2022-11-20', 4, 65000.00, NULL),           -- E005 = Senior Dev in IT
('E003', 2, '2024-01-01', 4, 50000.00, NULL);           -- E003 promoted to Senior Dev

-- 8. INSERT LEAVE TYPES
INSERT INTO leave_type (leave_name, paid, max_days_per_year) VALUES
('Vacation', 1, 15),
('Sick Leave', 1, 10),
('Unpaid Leave', 0, 30),
('Bereavement', 1, 5),
('Maternity', 1, 60);

-- 9. INSERT LEAVE REQUESTS (1:N relationship test)
INSERT INTO leave_request (leave_type_id, employee_id, start_date, end_date, reason, status) VALUES
(1, 'E001', '2025-06-01', '2025-06-05', 'Summer vacation', 'APPROVED'),
(2, 'E002', '2025-05-20', '2025-05-22', 'Flu', 'APPROVED'),
(1, 'E003', '2025-07-10', '2025-07-15', 'Family trip', 'PENDING'),
(4, 'E004', '2025-06-15', '2025-06-17', 'Father funeral', 'APPROVED'),
(2, 'E005', '2025-05-25', '2025-05-26', 'Migraine', 'PENDING');

-- 10. INSERT OVERTIME TYPES
INSERT INTO overtime_type (description, rate_multiplier) VALUES
('Regular OT', 1.25),
('Holiday OT', 1.50),
('Night OT', 1.30);

-- 11. INSERT OVERTIME ENTRIES (1:N relationship test)
INSERT INTO overtime_entry (overtime_type_id, employee_id, work_date, hours) VALUES
(1, 'E001', '2025-05-20', 2.0),
(1, 'E003', '2025-05-19', 1.5),
(2, 'E002', '2025-05-18', 3.0),
(3, 'E005', '2025-05-17', 2.5),
(1, 'E004', '2025-05-16', 1.0);

-- 12. INSERT ATTENDANCE (Composite PK test)
INSERT INTO attendance (employee_id, work_date, hours_worked) VALUES
('E001', '2025-05-20', 8.0),
('E001', '2025-05-21', 8.0),
('E002', '2025-05-20', 8.0),
('E002', '2025-05-21', 7.5),
('E003', '2025-05-20', 8.0),
('E003', '2025-05-21', 8.0),
('E004', '2025-05-20', 8.0),
('E005', '2025-05-20', 9.0);

-- 13. INSERT PAYROLL EARNING TYPES
INSERT INTO payroll_earning_type (name, taxable) VALUES
('Basic Salary', 1),
('Overtime Pay', 1),
('Allowances', 1),
('Bonus', 1);

-- 14. INSERT PAYROLL DEDUCTION TYPES
INSERT INTO payroll_deduction_type (name, government_mandated) VALUES
('SSS Contribution', 1),
('PhilHealth', 1),
('Pag-IBIG', 1),
('Income Tax', 1),
('Loan Deduction', 0);

-- 15. INSERT WITHHOLDING TAX BRACKETS
INSERT INTO withholding_tax_bracket (min_salary, max_salary, tax_rate, effective_date, end_date) VALUES
(0, 25000, 0.00, '2025-01-01', NULL),
(25001, 50000, 0.05, '2025-01-01', NULL),
(50001, 75000, 0.10, '2025-01-01', NULL),
(75001, 100000, 0.15, '2025-01-01', NULL),
(100001, NULL, 0.20, '2025-01-01', NULL);

-- 16. INSERT PAYROLL (1:N relationship test)
INSERT INTO payroll (employee_id, pay_period_start, pay_period_end, gross_pay, total_deductions, net_pay) VALUES
('E001', '2025-05-01', '2025-05-15', 75000, 15000, 60000),
('E001', '2025-05-16', '2025-05-31', 75000, 15000, 60000),
('E002', '2025-05-01', '2025-05-15', 55000, 11000, 44000),
('E002', '2025-05-16', '2025-05-31', 55000, 11000, 44000),
('E003', '2025-05-01', '2025-05-15', 35000, 7000, 28000),
('E003', '2025-05-16', '2025-05-31', 35000, 7000, 28000),
('E004', '2025-05-01', '2025-05-15', 60000, 12000, 48000),
('E004', '2025-05-16', '2025-05-31', 60000, 12000, 48000),
('E005', '2025-05-01', '2025-05-15', 65000, 13000, 52000),
('E005', '2025-05-16', '2025-05-31', 65000, 13000, 52000);

-- 17. INSERT PAYROLL EARNINGS
INSERT INTO payroll_earning (earning_type_id, payroll_id, amount) VALUES
(1, 1, 75000),    -- Payroll 1: Basic salary
(3, 1, 5000),     -- Payroll 1: Allowances
(1, 2, 75000),    -- Payroll 2: Basic salary
(3, 2, 5000),     -- Payroll 2: Allowances
(1, 3, 55000),    -- Payroll 3: Basic salary
(3, 3, 3000),     -- Payroll 3: Allowances
(1, 4, 55000),
(3, 4, 3000),
(1, 5, 35000),
(3, 5, 2000),
(1, 6, 35000),
(3, 6, 2000),
(1, 7, 60000),
(3, 7, 3000),
(1, 8, 60000),
(3, 8, 3000),
(1, 9, 65000),
(3, 9, 4000),
(1, 10, 65000),
(3, 10, 4000);

-- 18. INSERT PAYROLL DEDUCTIONS
INSERT INTO payroll_deduction (bracket_id, deduction_type_id, payroll_id, amount) VALUES
(4, 1, 1, 3000),    -- SSS for payroll 1
(4, 2, 1, 2500),    -- PhilHealth
(4, 3, 1, 2000),    -- Pag-IBIG
(4, 4, 1, 7500),    -- Income Tax
(4, 1, 2, 3000),
(4, 2, 2, 2500),
(4, 3, 2, 2000),
(4, 4, 2, 7500),
(3, 1, 3, 2200),
(3, 2, 3, 1800),
(3, 3, 3, 1500),
(3, 4, 3, 5500),
(3, 1, 4, 2200),
(3, 2, 4, 1800),
(3, 3, 4, 1500),
(3, 4, 4, 5500),
(2, 1, 5, 1400),
(2, 2, 5, 1100),
(2, 3, 5, 900),
(2, 4, 5, 3600),
(2, 1, 6, 1400),
(2, 2, 6, 1100),
(2, 3, 6, 900),
(2, 4, 6, 3600),
(3, 1, 7, 2400),
(3, 2, 7, 2000),
(3, 3, 7, 1600),
(3, 4, 7, 6000),
(3, 1, 8, 2400),
(3, 2, 8, 2000),
(3, 3, 8, 1600),
(3, 4, 8, 6000),
(3, 1, 9, 2600),
(3, 2, 9, 2100),
(3, 3, 9, 1700),
(3, 4, 9, 6600),
(3, 1, 10, 2600),
(3, 2, 10, 2100),
(3, 3, 10, 1700),
(3, 4, 10, 6600);