CREATE TABLE overtime_type (
    overtime_type_id INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(50) NOT NULL,
    rate_multiplier DECIMAL(4, 2) NOT NULL,
    CHECK (rate_multiplier > 0)
);