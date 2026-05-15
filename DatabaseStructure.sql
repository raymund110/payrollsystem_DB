-- employee table
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

-- attendance table
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

-- leave_type table
CREATE TABLE leave_type (
    leave_type_id INT PRIMARY KEY AUTO_INCREMENT,
    leave_name VARCHAR(50) UNIQUE NOT NULL,
    paid TINYINT(1) NOT NULL DEFAULT 1,
    max_days_per_year INT,
    CHECK (max_days_per_year >= 0)
);

-- leave_request table
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

-- overtime_type table
CREATE TABLE overtime_type (
    overtime_type_id INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(50) NOT NULL,
    rate_multiplier DECIMAL(4, 2) NOT NULL,
    CHECK (rate_multiplier > 0)
);

-- overtime_entry table
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

-- user_account table
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