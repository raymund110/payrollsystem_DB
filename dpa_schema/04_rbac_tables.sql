-- =========================================
-- Module: RBAC Tables
-- File: 04_rbac_tables.sql
-- Description:
--     Role-based access control tables
-- =========================================

USE payrollsystem_db;

CREATE TABLE role (
    role_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE permission (
    permission_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE role_permission (
    role_id INT UNSIGNED NOT NULL,
    permission_id INT UNSIGNED NOT NULL,

    PRIMARY KEY (role_id, permission_id),

    FOREIGN KEY (role_id) REFERENCES role(role_id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permission(permission_id) ON DELETE CASCADE
);

CREATE TABLE user_account (
    employee_pk BIGINT UNSIGNED PRIMARY KEY,

    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,

    role_id INT UNSIGNED NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_employee
        FOREIGN KEY (employee_pk)
        REFERENCES employee(employee_pk)
        ON DELETE CASCADE,

    CONSTRAINT fk_user_role
        FOREIGN KEY (role_id)
        REFERENCES role(role_id)
        ON DELETE RESTRICT
);