USE payrollsystem_db;

-- =========================================
-- SSS TABLE (Bracket-Based)
-- =========================================
DROP TABLE IF EXISTS sss_contribution_bracket;

CREATE TABLE sss_contribution_bracket (
    bracket_id INT AUTO_INCREMENT PRIMARY KEY,
    min_compensation DECIMAL(10,2),
    max_compensation DECIMAL(10,2),
    contribution DECIMAL(10,2)
);

INSERT INTO sss_contribution_bracket (min_compensation, max_compensation, contribution)
VALUES
(0, 3250, 135.00),
(3250, 3750, 157.50),
(3750, 4250, 180.00),
(4250, 4750, 202.50),
(4750, 5250, 225.00),
(5250, 5750, 247.50),
(5750, 6250, 270.00),
(6250, 6750, 292.50),
(6750, 7250, 315.00),
(7250, 7750, 337.50),
(7750, 8250, 360.00),
(8250, 8750, 382.50),
(8750, 9250, 405.00),
(9250, 9750, 427.50),
(9750, 10250, 450.00),
(10250, 10750, 472.50),
(10750, 11250, 495.00),
(11250, 11750, 517.50),
(11750, 12250, 540.00),
(12250, 12750, 562.50),
(12750, 13250, 585.00),
(13250, 13750, 607.50),
(13750, 14250, 630.00),
(14250, 14750, 652.50),
(14750, 15250, 675.00),
(15250, 15750, 697.50),
(15750, 16250, 720.00),
(16250, 16750, 742.50),
(16750, 17250, 765.00),
(17250, 17750, 787.50),
(17750, 18250, 810.00),
(18250, 18750, 832.50),
(18750, 19250, 855.00),
(19250, 19750, 877.50),
(19750, 20250, 900.00),
(20250, 20750, 922.50),
(20750, 21250, 945.00),
(21250, 21750, 967.50),
(21750, 22250, 990.00),
(22250, 22750, 1012.50),
(22750, 23250, 1035.00),
(23250, 23750, 1057.50),
(23750, 24250, 1080.00),
(24250, 24750, 1102.50),
(24750, 9999999, 1125.00);

-- =========================================
-- PHILHEALTH RULE
-- =========================================
DROP TABLE IF EXISTS philhealth_contribution_rule;

CREATE TABLE philhealth_contribution_rule (
    rule_id INT PRIMARY KEY,
    floor_amount DECIMAL(10,2),    -- e.g., 10,000.00
    ceiling_amount DECIMAL(10,2),  -- e.g., 60,000.00
    premium_rate DECIMAL(5,4),     -- 0.0300
    employee_share_rate DECIMAL(5,2) -- 0.50
);

INSERT INTO philhealth_contribution_rule VALUES (1, 10000.00, 60000.00, 0.03, 0.50);

-- =========================================
-- PAG-IBIG RULE
-- =========================================

DROP TABLE IF EXISTS pagibig_contribution_rule;

CREATE TABLE pagibig_contribution_rule (
    rule_id INT PRIMARY KEY,
    salary_threshold DECIMAL(10,2), -- 1500.00
    employee_rate DECIMAL(5,4),     -- 0.01 or 0.02
    employer_rate DECIMAL(5,4),     -- 0.02
    max_fund_salary DECIMAL(10,2)   -- 10000.00
);

INSERT INTO pagibig_contribution_rule VALUES 
(1, 1500.00, 0.01, 0.02, 10000.00),
(2, 9999999.00, 0.02, 0.02, 10000.00);