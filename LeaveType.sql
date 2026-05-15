CREATE TABLE leave_type (
    leave_type_id INT PRIMARY KEY AUTO_INCREMENT,
    leave_name VARCHAR(50) UNIQUE NOT NULL,
    paid TINYINT(1) NOT NULL DEFAULT 1,
    max_days_per_year INT,
    CHECK (max_days_per_year >= 0)
);