/*
===================================
employee -> supervisor -> employee_position -> position relationship
===================================
*/

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    p.position_name,
    e.supervisor_id,
    CONCAT(s.first_name, ' ', s.last_name) AS supervisor
FROM employee e
LEFT JOIN employee s
    ON e.supervisor_id = s.employee_id
LEFT JOIN employee_position ep
    ON e.employee_id = ep.employee_id
LEFT JOIN `position` p
    ON ep.position_id = p.position_id
ORDER BY e.employee_id;

-- Attempt to insert an employee with non-existing supervisor
INSERT INTO employee(employee_id, first_name, last_name, birthday, address,
	phone_number, sss_number, philhealth_number,
    tin_number, pagibig_number, status, supervisor_id)
VALUES('10035', 'Marcus', 'Santos', '1990-08-07', 'Agapita Building, Metro Manila',
	'526-129-511', '20-2537501-5', '122460050077', 
	'541-529-713-000', '123042259378', 'REGULAR', '99999');

/*
Show Contents
*/
SELECT 
	employee_id,
    first_name,
    last_name,
    supervisor_id
FROM employee
LIMIT 10;

SELECT * FROM position
ORDER BY position_id;

SELECT * FROM employee_position;