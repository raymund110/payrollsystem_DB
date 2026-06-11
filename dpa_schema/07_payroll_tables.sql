-- =========================================
-- Module: Payroll Tables
-- File: 07_payroll_tables.sql
-- Description:
--     Payroll processing and computation tables
-- =========================================

USE payrollsystem_db;

-- =========================================
-- PAYROLL
-- =========================================
CREATE TABLE payroll (
    payroll_id BIGINT UNSIGNED
        PRIMARY KEY AUTO_INCREMENT,

    employee_pk BIGINT UNSIGNED NOT NULL,

    payroll_status_id INT NOT NULL,

    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,

    gross_pay DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_deductions DECIMAL(12,2) NOT NULL DEFAULT 0,
    net_pay DECIMAL(12,2) NOT NULL DEFAULT 0,

    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payroll_employee
    FOREIGN KEY (employee_pk)
    REFERENCES employee(employee_pk)
    ON DELETE CASCADE,

    CONSTRAINT fk_payroll_status
    FOREIGN KEY (payroll_status_id)
    REFERENCES payroll_status(payroll_status_id)
    ON DELETE RESTRICT,

    CONSTRAINT uq_employee_payroll_period
    UNIQUE (
        employee_pk,
        pay_period_start,
        pay_period_end
    ),

    CONSTRAINT chk_payroll_dates
    CHECK (
        pay_period_end >= pay_period_start
    )
);

-- =========================================
-- WITHHOLDING TAX BRACKET
-- =========================================
CREATE TABLE withholding_tax_bracket (
    bracket_id INT PRIMARY KEY AUTO_INCREMENT,

    min_salary DECIMAL(12,2) NOT NULL,
    max_salary DECIMAL(12,2),

    base_tax DECIMAL(12,2) NOT NULL DEFAULT 0,

    excess_rate DECIMAL(5,4) NOT NULL,

    effective_date DATE NOT NULL,
    end_date DATE NULL,

    CONSTRAINT chk_min_salary
    CHECK (min_salary >= 0),

    CONSTRAINT chk_base_tax
    CHECK (base_tax >= 0),

    CONSTRAINT chk_excess_rate
    CHECK (excess_rate >= 0)
);

-- =========================================
-- PAYROLL EARNING
-- =========================================
CREATE TABLE payroll_earning (
    earning_id BIGINT UNSIGNED
        PRIMARY KEY AUTO_INCREMENT,

    payroll_id BIGINT UNSIGNED NOT NULL,

    earning_type_id INT NOT NULL,

    amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_payroll_earning_payroll
    FOREIGN KEY (payroll_id)
    REFERENCES payroll(payroll_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_payroll_earning_type
    FOREIGN KEY (earning_type_id)
    REFERENCES payroll_earning_type(earning_type_id)
    ON DELETE RESTRICT,

    CONSTRAINT chk_payroll_earning_amount
    CHECK (amount >= 0)
);

-- =========================================
-- PAYROLL DEDUCTION
-- =========================================
CREATE TABLE payroll_deduction (
    deduction_id BIGINT UNSIGNED
        PRIMARY KEY AUTO_INCREMENT,

    payroll_id BIGINT UNSIGNED NOT NULL,

    deduction_type_id INT NOT NULL,

    bracket_id INT NULL,

    amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_payroll_deduction_payroll
    FOREIGN KEY (payroll_id)
    REFERENCES payroll(payroll_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_payroll_deduction_type
    FOREIGN KEY (deduction_type_id)
    REFERENCES payroll_deduction_type(deduction_type_id)
    ON DELETE RESTRICT,

    CONSTRAINT fk_payroll_deduction_bracket
    FOREIGN KEY (bracket_id)
    REFERENCES withholding_tax_bracket(bracket_id)
    ON DELETE SET NULL,

    CONSTRAINT chk_payroll_deduction_amount
    CHECK (amount >= 0)
);