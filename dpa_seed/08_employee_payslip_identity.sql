--- =========================================
--- Module: Employee Payslip Reporting
--- Should be run every time the payslip changes cutoff date
--- =========================================

USE payrollsystem_db;

CREATE TABLE IF NOT EXISTS employee_payslip_identity (
    payslip_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    employee_pk INT NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,

    payslip_no VARCHAR(30) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_employee_period (employee_pk, period_start),
    UNIQUE KEY uq_payslip_no (payslip_no)
);