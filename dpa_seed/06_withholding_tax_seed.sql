USE payrollsystem_db;


ALTER TABLE withholding_tax_bracket
ADD UNIQUE KEY uq_withholding_bracket
(
    min_salary,
    max_salary,
    effective_date
);


INSERT INTO withholding_tax_bracket
(
    min_salary,
    max_salary,
    base_tax,
    excess_rate,
    effective_date
)
VALUES

-- Monthly 20,832 and below
(0, 20832, 0, 0.0000, '2024-01-01'),

-- 20,833 - 33,332
(20833, 33332, 0, 0.2000, '2024-01-01'),

-- 33,333 - 66,666
(33333, 66666, 2500, 0.2500, '2024-01-01'),

-- 66,667 - 166,666
(66667, 166666, 10833, 0.3000, '2024-01-01'),

-- 166,667 - 666,666
(166667, 666666, 40833.33, 0.3200, '2024-01-01'),

-- 666,667 and above
(666667, NULL, 200833.33, 0.3500, '2024-01-01')


ON DUPLICATE KEY UPDATE

    base_tax = VALUES(base_tax),

    excess_rate = VALUES(excess_rate);