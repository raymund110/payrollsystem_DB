-- =========================================
-- Module: Employee Payslip Testing
-- File: 02_employee_payslip_test.sql
-- Description:
-- Executes payslip report testing
-- and verification queries.
-- =========================================

USE payrollsystem_db;


-- =========================================
-- VERIFY VIEW EXISTS
-- =========================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';



-- =========================================
-- DISPLAY SAMPLE PAYSLIP RECORDS
-- =========================================

SELECT *
FROM vw_employee_payslip
LIMIT 10;



-- =========================================
-- VERIFY EMPLOYEE MASTER DATA
-- =========================================

SELECT

    employee_pk,

    employee_no,

    CONCAT(
        last_name,
        ', ',
        first_name
    ) AS employee_name

FROM employee

ORDER BY employee_no;



-- =========================================
-- TEST SINGLE EMPLOYEE PAYSLIP
-- Example: Fredrick Romualdez
-- =========================================

SELECT *

FROM vw_employee_payslip

WHERE employee_id = '10015';



-- =========================================
-- END OF FILE
-- =========================================