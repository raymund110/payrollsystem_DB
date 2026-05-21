USE payrollsystem_db;

-- Testing Leave Management relationships

-- insert leave types
INSERT INTO leave_type (leave_name, paid, max_days_per_year)
VALUES
    ('Sick Leave', 1, 15),
    ('Vacation Leave', 1, 15),
    ('Emergency Leave', 1, 5),
    ('Maternity Leave', 1, 105);

-- insert leave requests for all employees
INSERT INTO leave_request (
    leave_type_id,
    employee_id,
    start_date,
    end_date,
    reason,
    status
) VALUES
    (1, 'E001', '2026-06-01', '2026-06-03', 'Flu and fever', 'APPROVED'),
    (2, 'E002', '2026-06-10', '2026-06-12', 'Family vacation', 'PENDING'),
    (3, 'E003', '2026-06-15', '2026-06-15', 'Personal emergency', 'APPROVED'),
    (1, 'E004', '2026-06-20', '2026-06-22', 'Medical checkup', 'REJECTED'),
    (2, 'E005', '2026-06-25', '2026-06-27', 'Out of town trip', 'PENDING');