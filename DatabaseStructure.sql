-- Employee Self Service Portal
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


-- Time & Attendance Tracking
-- attendance table
CREATE TABLE attendance (
    employee_id VARCHAR(10),
    work_date DATE,
    hours_worked DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (employee_id, work_date), -- Composite PK
    -- Foreign key relationship
    CONSTRAINT fk_attendance_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,
    CHECK (hours_worked >= 0)
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
CREATE TABLE payroll_deduction_type (
    deduction_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    government_mandated TINYINT(1) NOT NULL DEFAULT 1
);

-- payroll_earning_type table
CREATE TABLE payroll_earning_type (
    earning_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    taxable TINYINT(1) NOT NULL DEFAULT 1
);

-- withholding_tax_bracket table
CREATE TABLE withholding_tax_bracket (
    bracket_id INT PRIMARY KEY AUTO_INCREMENT,
    min_salary DECIMAL(10,2) NOT NULL,
    max_salary DECIMAL(10,2),
    tax_rate DECIMAL(5,4) NOT NULL,
    effective_date DATE NOT NULL,
    end_date DATE,
    CHECK (min_salary >= 0),
    CHECK (tax_rate >= 0)
);

-- payroll table
CREATE TABLE payroll (
    payroll_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(10) NOT NULL,
    pay_period_start DATE NOT NULL,
    gross_pay DECIMAL(10,2),
    total_deductions DECIMAL(10,2),
    net_pay DECIMAL(10,2),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pay_period_end DATE NOT NULL,
    -- Foreign key relationship
    CONSTRAINT fk_payroll_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
    ON DELETE CASCADE,
    CONSTRAINT uq_employee_period
    UNIQUE (employee_id, pay_period_start, pay_period_end),
    CHECK (pay_period_end >= pay_period_start)
);

-- payroll_earning table
CREATE TABLE payroll_earning (
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
CREATE TABLE payroll_deduction (
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
-- depertment table
CREATE TABLE department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- position table
CREATE TABLE position (
    position_id INT PRIMARY KEY AUTO_INCREMENT,
    position_name VARCHAR(50) NOT NULL UNIQUE
);

-- employee_position table
CREATE TABLE employee_position (
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
    CHECK (basic_salary >= 0)
);

-- allowance_type table
CREATE TABLE allowance_type (
    allowance_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- position_allowance table
CREATE TABLE position_allowance (
    position_id INT,
    allowance_type_id INT,
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