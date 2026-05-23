-- =========================================
-- Module: Attendance Tables
-- File: 06_attendance_tables.sql
-- Description:
--     Attendance and overtime records
-- =========================================

USE payrollsystem_db;

CREATE TABLE attendance_record (
    attendance_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,

    employee_pk BIGINT UNSIGNED NOT NULL,
    attendance_date DATE NOT NULL,

    time_in TIME NULL,
    time_out TIME NULL,

    hours_worked DECIMAL(5,2) DEFAULT 0,
    late_minutes INT DEFAULT 0,
    undertime_minutes INT DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_attendance_employee
        FOREIGN KEY (employee_pk)
        REFERENCES employee(employee_pk)
        ON DELETE CASCADE,

    CONSTRAINT uq_employee_attendance
        UNIQUE (employee_pk, attendance_date),

    CONSTRAINT chk_hours_worked CHECK (hours_worked >= 0),
    CONSTRAINT chk_late_minutes CHECK (late_minutes >= 0),
    CONSTRAINT chk_undertime_minutes CHECK (undertime_minutes >= 0)
);

CREATE INDEX idx_attendance_date
ON attendance_record(attendance_date);

-- =========================================
-- OVERTIME ENTRY
-- =========================================
CREATE TABLE overtime_entry (
    overtime_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,

    employee_pk BIGINT UNSIGNED NOT NULL,
    overtime_type_id INT NOT NULL,

    overtime_date DATE NOT NULL,
    hours DECIMAL(5,2) NOT NULL,

    approved_by BIGINT UNSIGNED NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_overtime_employee
        FOREIGN KEY (employee_pk)
        REFERENCES employee(employee_pk)
        ON DELETE CASCADE,

    CONSTRAINT fk_overtime_type
        FOREIGN KEY (overtime_type_id)
        REFERENCES overtime_type(overtime_type_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_overtime_approver
        FOREIGN KEY (approved_by)
        REFERENCES employee(employee_pk)
        ON DELETE SET NULL,

    CONSTRAINT chk_overtime_hours CHECK (hours > 0)
);

CREATE INDEX idx_overtime_approver ON overtime_entry(approved_by);