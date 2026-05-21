
-- Testing user_account relationships
-- insert roles
INSERT INTO role (role_name) VALUES
    ('ADMIN'),
    ('HR'),
    ('PAYROLL'),
    ('EMPLOYEE');

-- insert persmissions
INSERT INTO permission (permission_name) VALUES
    ('MANAGE_USERS'),
    ('VIEW_PAYROLL'),
    ('EDIT_PAYROLL'),
    ('VIEW_EMPLOYEES'),
    ('EDIT_EMPLOYEES');

-- insert role permission
-- Admin: All permissions
INSERT INTO role_permission (role_id, permission_id) VALUES
    -- ADMIN gets everything
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
    -- HR can view/edit employees
    (2, 4), (2, 5),
    -- PAYROLL can view/edit payroll
    (3, 2), (3, 3),
    -- EMPLOYEE can only view themselves
    (4, 4);

-- insert test employees
INSERT INTO employee (employee_id, first_name, last_name, birthday, address, phone_number, 
                      sss_number, philhealth_number, tin_number, pagibig_number, status, supervisor_id) VALUES
    ('E001', 'Juan', 'Dela Cruz', '1985-05-15', '123 Main St', '09171234567', 'SSS001', 'PH001', 'TIN001', 'PAG001', 'REGULAR', NULL),
    ('E002', 'Maria', 'Santos', '1990-08-20', '456 Oak Ave', '09171234568', 'SSS002', 'PH002', 'TIN002', 'PAG002', 'REGULAR', 'E001'),
    ('E003', 'Pedro', 'Reyes', '1992-03-10', '789 Pine St', '09171234569', 'SSS003', 'PH003', 'TIN003', 'PAG003', 'PROBATIONARY', 'E001'),
    ('E004', 'Ana', 'Garcia', '1988-12-25', '321 Elm Dr', '09171234570', 'SSS004', 'PH004', 'TIN004', 'PAG004', 'REGULAR', 'E001'),
    ('E005', 'Miguel', 'Lopez', '1995-07-30', '654 Birch Ln', '09171234571', 'SSS005', 'PH005', 'TIN005', 'PAG005', 'REGULAR', 'E002');

-- insert user accounts
INSERT INTO user_account (employee_id, username, password_hash, role_id, is_active) VALUES
    ('E001', 'juan_admin', 'hashed_pwd_001', 1, 1), -- Admin role
    ('E002', 'maria_hr', 'hashed_pwd_002', 2, 1), -- HR Manager role
    ('E003', 'pedro_employee', 'hashed_pwd_003', 4, 1), -- Employee role
    ('E004', 'ana_payroll', 'hashed_pwd_004', 3, 1); -- Payroll Officer role
