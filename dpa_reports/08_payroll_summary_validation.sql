-- =========================================
-- Column integrity (schema check)
-- Ensures your view has all required fields:

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vw_payroll_summary'
ORDER BY ORDINAL_POSITION;

-- No NULL violations (data integrity)

SELECT *
FROM vw_payroll_summary
WHERE employee_no IS NULL
   OR position_name IS NULL
   OR department_name IS NULL;


-- Numeric fields must not be negative (optional rule)

SELECT *
FROM vw_payroll_summary
WHERE gross_income < 0
   OR sss_contribution < 0
   OR philhealth_contribution < 0
   OR pagibig_contribution < 0
   OR withholding_tax < 0
   OR net_pay < 0;


-- Net pay correctness (core payroll logic)

SELECT
    employee_no,
    gross_income,
    total_benefits,

    sss_contribution,
    philhealth_contribution,
    pagibig_contribution,
    withholding_tax,

    net_pay,

    ROUND(
        gross_income
        + total_benefits
        - sss_contribution
        - philhealth_contribution
        - pagibig_contribution
        - withholding_tax
    ,2) AS computed_net_pay,

    net_pay -
    ROUND(
        gross_income
        + total_benefits
        - sss_contribution
        - philhealth_contribution
        - pagibig_contribution
        - withholding_tax
    ,2) AS difference
FROM vw_payroll_core
WHERE employee_no = '10005';


-- Contribution consistency (SSS, Philhealth, Pag-ibig existence)

SELECT *
FROM vw_payroll_summary
WHERE sss_contribution IS NULL
   OR philhealth_contribution IS NULL
   OR pagibig_contribution IS NULL;


-- Duplicate employee_no check (data integrity)

SELECT employee_no, COUNT(*) AS cnt
FROM vw_payroll_summary
GROUP BY employee_no
HAVING COUNT(*) > 1;

-- Check for employees with zero or negative gross income (data integrity)

SELECT
    employee_no,
    gross_income
FROM vw_payroll_summary
WHERE gross_income <= 0;

-- Payroll summary totals validation
SELECT
    ROUND(SUM(gross_income),2) AS gross_total,
    ROUND(SUM(net_pay),2) AS net_total
FROM vw_payroll_summary;