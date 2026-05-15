CREATE TABLE leave_request (
    leave_type_id INT NOT NULL,
    leave_request_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(10) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    status ENUM ('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP NULL,
    -- Foreign key relationship
    -- Employee Table
    CONSTRAINT fk_lr_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,
    -- LeaveType Table
    CONSTRAINT fk_lr_type
    FOREIGN KEY (leave_type_id)
    REFERENCES leave_type(leave_type_id),
    CHECK (end_date >= start_date)
);