/*
===================================
Attendance flow and constraints
===================================
*/
-- Login
INSERT INTO attendance(employee_id, work_date, log_in)
VALUES('10010', '2025-06-14', '09:28:00');

SELECT * FROM attendance
WHERE employee_id = '10010' AND work_date = '2025-06-14';

-- Logout
UPDATE attendance
SET log_out = '19:24:00', hours_worked = 9.93
WHERE employee_id = '10010' AND work_date = '2025-06-14';

-- INVALID LOGOUT | CHECK VIOLATION
-- Logout cannot have a NULL log_out or hours_worked
UPDATE attendance
SET log_out = '19:24:00'
WHERE employee_id = '10010' AND work_date = '2025-06-14';

-- DElete
DELETE FROM attendance
WHERE employee_id = '10010' AND work_date = '2025-06-14';