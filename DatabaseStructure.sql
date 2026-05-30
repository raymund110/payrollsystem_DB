CREATE DATABASE IF NOT EXISTS payrollsystem_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE payrollsystem_db;

-- Employee Self Service Portal
-- employee table
CREATE TABLE IF NOT EXISTS employee (
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- Foreign key relationship
    CONSTRAINT fk_employee_supervisor
    FOREIGN KEY (supervisor_id)
    REFERENCES employee(employee_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

-- leave_type table
CREATE TABLE IF NOT EXISTS leave_type (
    leave_type_id INT PRIMARY KEY AUTO_INCREMENT,
    leave_name VARCHAR(50) UNIQUE NOT NULL,
    paid TINYINT(1) NOT NULL DEFAULT 1,
    max_days_per_year INT,
    CHECK (max_days_per_year >= 0)
);

-- leave_request table
CREATE TABLE IF NOT EXISTS leave_request (
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

-- Normalize user_account
-- role table
CREATE TABLE IF NOT EXISTS role (
    role_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- permission table
CREATE TABLE IF NOT EXISTS permission (
    permission_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(100) NOT NULL UNIQUE
);

-- role_permission junction table
CREATE TABLE IF NOT EXISTS role_permission (
    role_id INT UNSIGNED NOT NULL,
    permission_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (role_id, permission_id),

    CONSTRAINT fk_rp_role
    FOREIGN KEY (role_id)
    REFERENCES role(role_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_rp_permission
    FOREIGN KEY (permission_id)
    REFERENCES permission(permission_id)
    ON DELETE CASCADE
);

-- user_account table
CREATE TABLE IF NOT EXISTS user_account (
    employee_id VARCHAR(10) PRIMARY KEY, -- no employee = no account shared PK
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,

    role_id INT UNSIGNED NOT NULL DEFAULT 4, -- 3 = employee
    is_active TINYINT(1) NOT NULL DEFAULT 1,

    -- Foreign key relationship
    -- Employee table
    CONSTRAINT fk_user_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,

    -- Role table
    CONSTRAINT fk_user_role
    FOREIGN KEY (role_id)
    REFERENCES role(role_id)
    ON DELETE RESTRICT
);


-- Time & Attendance Tracking
-- attendance table
CREATE TABLE IF NOT EXISTS attendance (
    employee_id VARCHAR(10) NOT NULL,
    work_date DATE NOT NULL,

    log_in TIME NOT NULL,
    log_out TIME NULL, -- NULL until employee logs out

    hours_worked DECIMAL(5, 2) NULL, -- computed after logout in backend application code
    PRIMARY KEY (employee_id, work_date),

    -- Foreign key relationship
    CONSTRAINT fk_attendance_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,
    CHECK (log_out >= log_in OR log_out IS NULL),
    CHECK (hours_worked >= 0 OR hours_worked IS NULL),
    CHECK (
        (log_out IS NULL AND hours_worked IS NULL)
        OR
        (log_out IS NOT NULL AND hours_worked IS NOT NULL)
    )
);

-- overtime_type table
CREATE TABLE IF NOT EXISTS overtime_type (
    overtime_type_id INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(50) NOT NULL,
    rate_multiplier DECIMAL(4, 2) NOT NULL,
    CHECK (rate_multiplier > 0)
);

-- overtime_entry table
CREATE TABLE IF NOT EXISTS overtime_entry (
    overtime_type_id INT NOT NULL,
    overtime_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
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


-- Payroll Admin Role
-- payroll_deduction_type table
CREATE TABLE IF NOT EXISTS payroll_deduction_type (
    deduction_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    government_mandated TINYINT(1) NOT NULL DEFAULT 1
);

-- payroll_earning_type table
CREATE TABLE IF NOT EXISTS payroll_earning_type (
    earning_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    taxable TINYINT(1) NOT NULL DEFAULT 1
);

-- withholding_tax_bracket table
CREATE TABLE IF NOT EXISTS withholding_tax_bracket (
    bracket_id INT PRIMARY KEY AUTO_INCREMENT,
    min_salary DECIMAL(10,2) NOT NULL,
    max_salary DECIMAL(10,2),
    tax_rate DECIMAL(5,4) NOT NULL,
    effective_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CHECK (min_salary >= 0),
    CHECK (tax_rate >= 0)
);

-- payroll table
CREATE TABLE IF NOT EXISTS payroll (
    payroll_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(10) NOT NULL,
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,

    gross_pay DECIMAL(10,2) NOT NULL,
    total_deductions DECIMAL(10,2) NOT NULL,
    net_pay DECIMAL(10,2) NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key relationship
    CONSTRAINT fk_payroll_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,

    CONSTRAINT uq_employee_period
    UNIQUE (employee_id, pay_period_start, pay_period_end),

    CHECK (pay_period_end >= pay_period_start),
    CHECK (gross_pay >= 0),
    CHECK (total_deductions >= 0),
    CHECK (net_pay >= 0),
    CHECK (net_pay = gross_pay - total_deductions)
);

-- payroll_earning table
CREATE TABLE IF NOT EXISTS payroll_earning (
    earning_type_id INT NOT NULL,
    payroll_id BIGINT UNSIGNED NOT NULL,
    earning_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10,2) NOT NULL,

    -- Foreign key relationship
    -- Payroll Table
    CONSTRAINT fk_pe_payroll
    FOREIGN KEY (payroll_id)
    REFERENCES payroll(payroll_id)
    ON DELETE CASCADE,

    -- PayrollEarningType Table
    CONSTRAINT fk_pe_type
    FOREIGN KEY (earning_type_id)
    REFERENCES payroll_earning_type(earning_type_id),
    CHECK (amount >= 0)
);

-- payroll_deduction table
CREATE TABLE IF NOT EXISTS payroll_deduction (
    bracket_id INT NOT NULL,
    deduction_type_id INT NOT NULL,
    payroll_id BIGINT UNSIGNED NOT NULL,
    deduction_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10,2) NOT NULL,

    -- Foreign key relationship
    -- Payroll Table
    CONSTRAINT fk_pd_payroll
    FOREIGN KEY (payroll_id)
    REFERENCES payroll(payroll_id)
    ON DELETE CASCADE,

    -- PayrollDeductionType Table
    CONSTRAINT fk_pd_type
    FOREIGN KEY (deduction_type_id)
    REFERENCES payroll_deduction_type(deduction_type_id),
    
    -- WithholdingTaxBracket Table
    CONSTRAINT fk_pd_bracket
    FOREIGN KEY (bracket_id)
    REFERENCES withholding_tax_bracket(bracket_id),
    CHECK (amount >= 0)
);

-- Salary Calculation
-- department table
CREATE TABLE IF NOT EXISTS department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- position table
CREATE TABLE IF NOT EXISTS position (
    position_id INT PRIMARY KEY AUTO_INCREMENT,
    position_name VARCHAR(50) NOT NULL UNIQUE
);

-- employee_position table
CREATE TABLE IF NOT EXISTS employee_position (
    employee_id VARCHAR(10) NOT NULL,
    position_id INT NOT NULL,
    effective_date DATE NOT NULL,
    dept_id INT NOT NULL,
    basic_salary DECIMAL(10,2) NOT NULL,
    end_date DATE,
    PRIMARY KEY (employee_id, position_id, effective_date), -- COmposite PK

    -- Foreign key relationship
    -- Employee Table
    CONSTRAINT fk_ep_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,

    -- Position Table
    CONSTRAINT fk_ep_position
    FOREIGN KEY (position_id)
    REFERENCES `position`(position_id)
    ON DELETE RESTRICT,

    -- Department Table
    CONSTRAINT fk_ep_department
    FOREIGN KEY (dept_id)
    REFERENCES department(dept_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CHECK (basic_salary >= 0),
    CHECK (end_date IS NULL OR end_date >= effective_date)
);

-- allowance_type table
CREATE TABLE IF NOT EXISTS allowance_type (
    allowance_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- position_allowance table
CREATE TABLE IF NOT EXISTS position_allowance (
    position_id INT NOT NULL,
    allowance_type_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (position_id, allowance_type_id), -- Composite PK

    -- Foreign key relationship
    -- Position table
    CONSTRAINT fk_pa_position
    FOREIGN KEY (position_id)
    REFERENCES `position`(position_id)
    ON DELETE CASCADE,
    
    -- Allowance_type Table
    CONSTRAINT fk_pa_type
    FOREIGN KEY (allowance_type_id)
    REFERENCES allowance_type(allowance_type_id),
    CHECK (amount >= 0)
);