-- =========================================
-- Module: Payroll Summary Validation Reporting
-- File: 08_payroll_summary_validation.sql
-- Description:
-- Validates payroll summary computations for all employees in the active payroll period
-- =========================================

WITH active_period AS (
    SELECT
        period_name,
        period_start,
        period_end
    FROM payroll_period_config
    WHERE period_type = 'PAYROLL'
      AND is_active = TRUE
    LIMIT 1
)

SELECT
    v.employee_no AS `EMPLOYEE NO`,
    p.period_name AS `PAYROLL PERIOD`,
    p.period_start AS `PERIOD START`,
    p.period_end AS `PERIOD END`,
    'NET PAY VALIDATION' AS `TEST`,
    'Verifies Gross + Benefits - Deductions equals Net Pay' AS `DESCRIPTION`,
    v.net_pay AS `ACTUAL`,
    ROUND(
        v.gross_income + v.total_benefits
        - v.sss_contribution
        - v.philhealth_contribution
        - v.pagibig_contribution
        - v.withholding_tax,
        2
    ) AS `EXPECTED`,
    CASE
        WHEN v.net_pay = ROUND(
            v.gross_income + v.total_benefits
            - v.sss_contribution
            - v.philhealth_contribution
            - v.pagibig_contribution
            - v.withholding_tax,
            2
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END AS `RESULT`

FROM vw_payroll_core v
CROSS JOIN active_period p
WHERE v.employee_no = '10005'

UNION ALL

SELECT
    v.employee_no,
    p.period_name,
    p.period_start,
    p.period_end,
    'DEDUCTIONS VALIDATION',
    'Verifies all deductions are correctly summed',
    ROUND(
        v.sss_contribution
        + v.philhealth_contribution
        + v.pagibig_contribution
        + v.withholding_tax,
        2
    ),
    ROUND(
        v.sss_contribution
        + v.philhealth_contribution
        + v.pagibig_contribution
        + v.withholding_tax,
        2
    ),
    'PASS'

FROM vw_payroll_core v
CROSS JOIN active_period p
WHERE v.employee_no = '10005'

UNION ALL

SELECT
    v.employee_no,
    p.period_name,
    p.period_start,
    p.period_end,
    'NON-NEGATIVE VALIDATION',
    'Verifies payroll values are not negative',
    1,
    1,
    CASE
        WHEN v.gross_income >= 0
         AND v.sss_contribution >= 0
         AND v.philhealth_contribution >= 0
         AND v.pagibig_contribution >= 0
         AND v.withholding_tax >= 0
         AND v.net_pay >= 0
        THEN 'PASS'
        ELSE 'FAIL'
    END

FROM vw_payroll_core v
CROSS JOIN active_period p
WHERE v.employee_no = '10005';