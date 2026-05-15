CREATE TABLE user_account (
    username VARCHAR(50) PRIMARY KEY,
    password_hash VARCHAR(128) NOT NULL,
    role ENUM ('ADMIN','HR','PAYROLL','EMPLOYEE') NOT NULL DEFAULT 'EMPLOYEE',
    employee_id VARCHAR(10) UNIQUE,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    -- Foreign key relationship
    CONSTRAINT fk_user_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE SET NULL
);