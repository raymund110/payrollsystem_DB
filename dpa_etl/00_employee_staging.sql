USE payrollsystem_db;

DROP TABLE IF EXISTS employee_staging;

CREATE TABLE employee_staging (

    staging_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,

    employee_no VARCHAR(10),

    last_name VARCHAR(100),
    first_name VARCHAR(100),

    birthday DATE,

    address TEXT,
    phone VARCHAR(30),

    sss VARCHAR(30),
    philhealth VARCHAR(30),
    tin VARCHAR(30),
    pagibig VARCHAR(30),

    employment_status VARCHAR(30),

    job_position VARCHAR(100),

    supervisor_name VARCHAR(100),

    basic_salary DECIMAL(10,2),

    rice_subsidy DECIMAL(10,2),
    phone_allowance DECIMAL(10,2),
    clothing_allowance DECIMAL(10,2),

    gross_semi_monthly DECIMAL(10,2),
    hourly_rate DECIMAL(10,2),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);