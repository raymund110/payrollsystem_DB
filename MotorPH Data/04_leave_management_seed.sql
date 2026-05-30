
USE payrollsystem_db;

-- Leave Type
INSERT INTO leave_type (leave_name, paid, max_days_per_year) VALUES
  ('Vacation Leave', 1, 15),
  ('Sick Leave', 1,  15),
  ('Emergency Leave', 1, 5),
  ('Maternity Leave', 1, 105),
  ('Paternity Leave', 1, 7),
  ('Unpaid Leave', 0, NULL);


-- Leave Requests
INSERT INTO leave_request (leave_type_id, employee_id, start_date, end_date, reason, status, requested_at, approved_at) VALUES
  (1, '10006', '2024-03-18', '2024-03-22', 'Personal vacation', 'APPROVED', '2024-03-10 10:00:00', '2024-03-11 09:00:00'),
  (2, '10008', '2024-04-15', '2024-04-16', 'Medical check-up', 'APPROVED', '2024-04-14 16:00:00', '2024-04-14 17:00:00'),
  (3, '10007', '2024-04-10', '2024-04-12', 'Family emergency', 'APPROVED', '2024-04-10 06:00:00', '2024-04-10 07:00:00'),
  (4, '10003', '2024-11-11', '2025-02-23', 'Maternity leave', 'APPROVED', '2024-10-01 09:00:00', '2024-10-02 10:00:00'),
  (5, '10015', '2024-06-03', '2024-06-07', 'Paternity leave for newborn', 'PENDING', '2024-05-25 09:00:00', NULL),
  (6, '10023', '2024-08-05', '2024-08-07', 'Personal reasons', 'REJECTED', '2024-07-29 10:00:00', NULL);