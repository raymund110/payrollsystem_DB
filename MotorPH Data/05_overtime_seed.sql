-- Insert Overtime samples

USE payrollsystem_db;

-- Overtime Type Seed Data

INSERT INTO overtime_type (description, rate_multiplier)
VALUES
  ('Regular Day Overtime', 1.25),
  ('Rest Day Overtime', 1.30),
  ('Special Holiday Overtime', 1.30),
  ('Regular Holiday Overtime', 2.60);


-- Sample Overtime Entries

INSERT INTO overtime_entry (overtime_type_id, employee_id, work_date, hours)
VALUES
  -- Employee 10001 | 2024-06-03 | worked 9.53 hrs → 1.53 OT hrs (Regular Day)
  (1, '10001', '2024-06-03', 1.53),

  -- Employee 10002 | 2024-06-03 | worked 9.15 hrs → 1.15 OT hrs (Regular Day)
  (1, '10002', '2024-06-03', 1.15),

  -- Employee 10006 | 2024-06-03 | worked 9.97 hrs → 1.97 OT hrs (Regular Day)
  (1, '10006', '2024-06-03', 1.97),

  -- Employee 10008 | 2024-06-03 | worked 9.07 hrs → 1.07 OT hrs (Regular Day)
  (1, '10008', '2024-06-03', 1.07),

  -- Employee 10003 | 2024-06-03 | worked 8.15 hrs → 0.15 OT hrs (Regular Day)
  (1, '10003', '2024-06-03', 0.15);