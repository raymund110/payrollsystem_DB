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
