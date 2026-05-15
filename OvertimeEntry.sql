CREATE TABLE overtime_entry (
    overtime_type_id INT NOT NULL,
    overtime_id BIGINT UNSIGNED PRIMARY KEY NOT NULL,
    employee_id VARCHAR(10) NOT NULL,
    work_date DATE NOT NULL,
    hours DECIMAL(4, 2) NOT NULL,
    -- Foreign key relationship
    -- Employee Table
    CONSTRAINT fk_ot_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,
    -- OvertimeType Table
    CONSTRAINT fk_ot_type
    FOREIGN KEY (overtime_type_id)
    REFERENCES overtime_type(overtime_type_id),
    CHECK (hours > 0)
);