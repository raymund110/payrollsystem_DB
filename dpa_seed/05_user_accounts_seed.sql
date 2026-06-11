-- =========================================
-- Module: User Account Seed
-- File: 08_user_accounts_seed.sql
-- =========================================

USE payrollsystem_db;

INSERT INTO user_account (
    employee_pk,
    username,
    password_hash,
    role_id,
    is_active
)
SELECT
    e.employee_pk,
    seed.username,
    seed.password_hash,
    seed.role_id,
    seed.is_active
FROM (
    SELECT '10001' AS employee_no,
           'mgarcia' AS username,
           'hashed_password_here' AS password_hash,
           1 AS role_id,
           1 AS is_active

    UNION ALL

    SELECT '10002',
           'alim',
           'hashed_password_here',
           2,
           1

    UNION ALL

    SELECT '10003',
           'baquino',
           'hashed_password_here',
           2,
           1
) seed

JOIN employee e
    ON e.employee_no = seed.employee_no;