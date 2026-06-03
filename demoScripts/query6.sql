/*
===================================
User Account one-to-one
===================================
*/

-- Only one employee can hava one user account
-- that is implemented using shared PK employee_id
INSERT INTO user_account (employee_id, username, password_hash, role_id, is_active)
VALUES ('10010', 'gorge_clean10023', 'hashedpassword123', 4, 1); -- Employee Role

-- EMPLOYEE 10010 is already existed
-- DUPLICATE violation
INSERT INTO user_account (employee_id, username, password_hash, role_id, is_active)
VALUES ('10010', 'gorge_clean10023', 'hashedpassword123', 4, 1); -- Employee Role

-- EMPLOYEE is NULL 
-- Foreign key constraint fails
INSERT INTO user_account (username, password_hash, role_id, is_active)
VALUES ('gorge_clean10023', 'hashedpassword123', 4, 1); -- Employee Role

-- Cascade delete
DELETE FROM employee
WHERE employee_id = '10010';

-- 0 rows returned
SELECT * FROM user_account
WHERE employee_id = '10010';

-- =======================
SELECT * FROM user_account;

SELECT * FROM  role;

DELETE FROM user_account
WHERE employee_id = '10010';