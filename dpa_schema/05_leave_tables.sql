-- =========================================
-- Module: Leave Management
-- File: 05_leave_tables.sql
-- Description:
--     Employee leave requests and approvals
-- =========================================

USE payrollsystem_db;

CREATE TABLE leave_request (
    leave_request_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,

    employee_pk BIGINT UNSIGNED NOT NULL,
    leave_type_id INT NOT NULL,
    leave_status_id INT NOT NULL,

    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    reason TEXT,

    approved_by BIGINT UNSIGNED NULL,
    approved_at TIMESTAMP NULL,

    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_leave_employee
        FOREIGN KEY (employee_pk)
        REFERENCES employee(employee_pk)
        ON DELETE CASCADE,

    CONSTRAINT fk_leave_type
        FOREIGN KEY (leave_type_id)
        REFERENCES leave_type(leave_type_id),

    CONSTRAINT fk_leave_status
        FOREIGN KEY (leave_status_id)
        REFERENCES leave_status(leave_status_id),

    CONSTRAINT fk_leave_approver
        FOREIGN KEY (approved_by)
        REFERENCES employee(employee_pk),

    CHECK (end_date >= start_date)
);