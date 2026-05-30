USE payrollsystem_db;

-- Testing Time & Attendance Tracking relationships

-- insert attendance records for all employees
INSERT INTO attendance (employee_id, work_date, hours_worked)
VALUES
    ('E001', '2026-05-01', 8.00),
    ('E002', '2026-05-01', 8.00),
    ('E003', '2026-05-01', 7.50),
    ('E004', '2026-05-01', 8.00),
    ('E005', '2026-05-01', 6.50);

-- insert overtime types
INSERT INTO overtime_type (description, rate_multiplier)
VALUES
    ('Regular Overtime', 1.25),
    ('Holiday Overtime', 1.50);

-- insert overtime entries for selected employees
INSERT INTO overtime_entry (overtime_type_id, employee_id, work_date, hours)
VALUES
    (1, 'E001', '2026-05-01', 2.00),
    (1, 'E002', '2026-05-01', 1.50),
    (2, 'E004', '2026-05-01', 3.00);