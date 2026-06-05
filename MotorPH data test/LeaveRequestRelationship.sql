/*
===================================
Leave Request Relationship
===================================
*/

SELECT
	e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    lt.leave_name,
    lr.start_date,
    lr.end_date,
    lr.reason
FROM leave_request lr
JOIN employee e
    ON lr.employee_id = e.employee_id
JOIN leave_type lt
    ON lr.leave_type_id = lt.leave_type_id;

-- Invalid dates
-- Violates CHECK constraints
INSERT INTO leave_request(leave_type_id, employee_id, start_date, end_date, reason)
VALUES (1, '10011', '2026-07-10', '2026-07-09', 'Personal vacation'); -- Vacation Leave

SELECT * FROM leave_type;
SELECT * FROM leave_request;