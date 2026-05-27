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

-- insert user accounts
INSERT INTO user_account (employee_id, username, password_hash, role_id, is_active) VALUES
    ('10001', 'garcia_10001', 'hashed_pwd_001', 1, 1), -- Admin role
    ('10006', 'villanueva_10006', 'hashed_pwd_002', 2, 1), -- HR Manager role
    ('10016', 'mata_10016', 'hashed_pwd_003', 4, 1), -- Employee role
    ('10011', 'salcedo_10011', 'hashed_pwd_004', 3, 1), -- Payroll Officer role
    ('10021', 'lazaro_10021', 'hashed_pwd_005', 4, 1); -- Employee role