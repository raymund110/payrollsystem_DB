-- =========================================
-- Module: Database Indexes
-- File: 08_indexes.sql
-- Description:
--     Performance optimization indexes
-- =========================================

USE payrollsystem_db;

CREATE INDEX idx_employee_supervisor
ON employee(supervisor_employee_pk);

CREATE INDEX idx_employee_no
ON employee(employee_no);

CREATE INDEX idx_employee_position_employee
ON employee_position(employee_pk);

CREATE INDEX idx_employment_history_employee
ON employee_employment_history(employee_pk);

CREATE INDEX idx_attendance_employee
ON attendance_record(employee_pk);

CREATE INDEX idx_attendance_date
ON attendance_record(attendance_date);

CREATE INDEX idx_payroll_employee
ON payroll(employee_pk);

CREATE INDEX idx_leave_employee
ON leave_request(employee_pk);

CREATE INDEX idx_overtime_employee
ON overtime_entry(employee_pk);