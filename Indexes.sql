-- Indexes

-- 1. Employee and User Account
-- Search employees by name (org charts, reports)
CREATE INDEX idx_employee_names
ON employee (last_name, first_name);

-- Find employees under supervisor (hierarchy queries)
CREATE INDEX idx_employee_supervisor
ON employee (supervisor_id);

-- Login queries: find active user by username
CREATE INDEX idx_user_auth_status
ON user_account (username, is_active);

-- 2. Leave Management
-- Find pending leave requests, filter by request date
CREATE INDEX idx_leave_request_status_date
ON leave_request (status, requested_at);

-- Get all leave requests for employee, check for overlapping dates
CREATE INDEX idx_leave_request_emp_dates
ON leave_request (employee_id, start_date, end_date);

-- 3. Attendance and Overtime
-- Find attendance records for payroll period, attendance reports by date
CREATE INDEX idx_attendance_date
ON attendance (work_date);

-- Get overtime entries for employee on specific date, overtime summary by employee/period
CREATE INDEX idx_overtime_entry_emp_date
ON overtime_entry (employee_id, work_date);

-- 4. Payroll
-- Find payroll records for period, prevent duplicate pay periods
CREATE INDEX idx_payroll_period
ON payroll (pay_period_start, pay_period_end);

-- Get all earnings for a payroll record (payroll detail queries)
CREATE INDEX idx_payroll_earning_pay_id
ON payroll_earning (payroll_id);

-- Get all deductions for a payroll record (payroll detail queries)
CREATE INDEX idx_payroll_deduction_pay_id
ON payroll_deduction (payroll_id);

-- Find active tax brackets for salary range lookups
CREATE INDEX idx_tax_bracket_effectivity
ON withholding_tax_bracket (effective_date, end_date);