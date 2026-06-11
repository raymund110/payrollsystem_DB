USE payrollsystem_db;

DROP TABLE IF EXISTS attendance_staging;

CREATE TABLE attendance_staging (
    attendance_staging_id BIGINT UNSIGNED
        PRIMARY KEY AUTO_INCREMENT,

    employee_no VARCHAR(10),

    last_name VARCHAR(100),
    first_name VARCHAR(100),

    attendance_date DATE,

    log_in TIME,
    log_out TIME,

    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);