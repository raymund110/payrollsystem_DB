-- =========================================
-- Module: Employee Tables
-- File: 03_employee_tables.sql
-- Description:
--     Employee master records
--     Employment history
--     Departments and positions
-- =========================================

USE payrollsystem_db;

CREATE TABLE employee (
    employee_pk BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    employee_no VARCHAR(10) NOT NULL UNIQUE,

    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    suffix VARCHAR(10),

    birthday DATE NOT NULL,
    address TEXT,
    phone_number VARCHAR(20),

    sss_number VARCHAR(30) UNIQUE,
    philhealth_number VARCHAR(30) UNIQUE,
    tin_number VARCHAR(30) UNIQUE,
    pagibig_number VARCHAR(30) UNIQUE,

    supervisor_employee_pk BIGINT UNSIGNED NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_employee_supervisor
        FOREIGN KEY (supervisor_employee_pk)
        REFERENCES employee(employee_pk)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE job_position (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employee_employment_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    employee_pk BIGINT UNSIGNED NOT NULL,
    status_name VARCHAR(30) NOT NULL,

    effective_date DATE NOT NULL,
    end_date DATE NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_eh_employee
        FOREIGN KEY (employee_pk)
        REFERENCES employee(employee_pk)
        ON DELETE CASCADE
);

CREATE TABLE employee_position (
    employee_pk BIGINT UNSIGNED NOT NULL,
    position_id INT NOT NULL,
    department_id INT NOT NULL,

    effective_date DATE NOT NULL,
    end_date DATE NULL,

    basic_salary DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (employee_pk, position_id, effective_date),

    CONSTRAINT fk_ep_employee
        FOREIGN KEY (employee_pk)
        REFERENCES employee(employee_pk)
        ON DELETE CASCADE,

    CONSTRAINT fk_ep_position
        FOREIGN KEY (position_id)
        REFERENCES job_position(position_id),

    CONSTRAINT fk_ep_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);