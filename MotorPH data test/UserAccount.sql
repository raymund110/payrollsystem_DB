/*
===================================
User Account one-to-one
===================================
*/

-- Non existing employee
INSERT INTO user_account (employee_id, username, password_hash, role_id, is_active)
VALUES ('99999', 'mister_clean10023', 'hashedpassword123', 4, 1); -- Employee Role

-- Only one employee can have one user account
-- that is implemented using shared PK employee_id
INSERT INTO user_account (employee_id, username, password_hash, role_id, is_active)
VALUES ('10032', 'mister_clean10023', 'hashedpassword123', 4, 1); -- Employee Role
SELECT * FROM user_account;

-- EMPLOYEE 10032 is already existed
-- DUPLICATE violation
INSERT INTO user_account (employee_id, username, password_hash, role_id, is_active)
VALUES ('10032', 'mister_clean10023', 'hashedpassword123', 4, 1); -- Employee Role

-- EMPLOYEE is NULL 
-- Foreign key constraint fails
INSERT INTO user_account (username, password_hash, role_id, is_active)
VALUES ('mister_clean10023', 'hashedpassword123', 4, 1); -- Employee Role

-- Cascade delete
DELETE FROM employee
WHERE employee_id = '10032';

-- 0 rows returned
SELECT * FROM user_account
WHERE employee_id = '10032';

-- =======================
SELECT * FROM user_account;

SELECT * FROM  role;

DELETE FROM user_account
WHERE employee_id = '10032';