CREATE TABLE attendance (
    employee_id VARCHAR(10),
    work_date DATE,
    hours_worked DECIMAL(5, 2) NOT NULL,
    -- Foreign key relationship
    CONSTRAINT fk_attendance_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,
    CHECK (hours_worked >= 0)
);