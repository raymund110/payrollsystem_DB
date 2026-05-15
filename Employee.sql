CREATE TABLE employee (
	employee_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL,
    address TEXT,
    phone_number VARCHAR(20),
    sss_number VARCHAR(20) UNIQUE,
    philhealth_number VARCHAR(20) UNIQUE,
    tin_number VARCHAR(20) UNIQUE,
    pagibig_number VARCHAR(20) UNIQUE,
    status ENUM ('REGULAR', 'PROBATIONARY') NOT NULL DEFAULT 'REGULAR',
    supervisor_id VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- Foreign key relationship
    CONSTRAINT fk_employee_supervisor
    FOREIGN KEY (supervisor_id)
    REFERENCES employee(employee_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);