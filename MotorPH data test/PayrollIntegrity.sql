/*
===================================
Payroll Integrity
===================================
*/

-- Valid Payroll
INSERT INTO payroll (employee_id, pay_period_start, pay_period_end, gross_pay, total_deductions, net_pay)
VALUES ('10002', '2025-07-01', '2025-07-15', 30000, 5000, 25000);

-- Invalid Payroll
-- CHECK constraints violated
-- Violates CHECK (net_pay = gross_pay - total_deductions)
INSERT INTO payroll (employee_id, pay_period_start, pay_period_end, gross_pay, total_deductions, net_pay)
VALUES ('10002', '2025-07-16', '2025-07-31', 30000, 5000, 26000);


SELECT * FROM payroll
WHERE employee_id = '10002' AND pay_period_start = '2025-07-16' AND pay_period_end = '2025-07-31';

SHOW INDEXES FROM payroll;