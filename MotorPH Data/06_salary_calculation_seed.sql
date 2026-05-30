
USE payrollsystem_db;

-- Department
INSERT INTO department (dept_name, description) VALUES
  ('Accounts', 'Manages client accounts, billing, and account-level customer relationships'),
  ('Customer Service','Handles customer inquiries, complaints, and after-sales support'),
  ('Executive', 'Senior leadership responsible for overall company strategy and operations'),
  ('Finance', 'Oversees financial planning, accounting, payroll processing, and reporting'),
  ('Human Resources', 'Manages recruitment, employee relations, benefits, and compliance'),
  ('IT', 'Maintains IT infrastructure, systems operations, and technical support'),
  ('Marketing', 'Drives brand strategy, promotions, and sales and marketing initiatives'),
  ('Supply Chain', 'Manages procurement, logistics, inventory, and supplier relationships');


-- Position
INSERT INTO `position` (position_name) VALUES
  ('Chief Executive Officer'),
  ('Chief Operating Officer'),
  ('Chief Finance Officer'),
  ('Chief Marketing Officer'),
  ('IT Operations and Systems'),
  ('HR Manager'),
  ('HR Team Leader'),
  ('HR Rank and File'),
  ('Accounting Head'),
  ('Payroll Manager'),
  ('Payroll Team Leader'),
  ('Payroll Rank and File'),
  ('Account Manager'),
  ('Account Team Leader'),
  ('Account Rank and File'),
  ('Sales & Marketing'),
  ('Supply Chain and Logistics'),
  ('Customer Service and Relations');


-- Allowance type
INSERT INTO allowance_type (name) VALUES
  ('Rice Subsidy'),
  ('Phone Allowance'),
  ('Clothing Allowance');


-- Postion Allowance
INSERT INTO position_allowance (position_id, allowance_type_id, amount) VALUES
  (1, 1, 1500.00), (1, 2, 2000.00), (1, 3, 1000.00),
  (2, 1, 1500.00), (2, 2, 2000.00), (2, 3, 1000.00),
  (3, 1, 1500.00), (3, 2, 2000.00), (3, 3, 1000.00),
  (4, 1, 1500.00), (4, 2, 2000.00), (4, 3, 1000.00),
  (5, 1, 1500.00), (5, 2, 1000.00), (5, 3, 1000.00),
  (6, 1, 1500.00), (6, 2, 1000.00), (6, 3, 1000.00),
  (7, 1, 1500.00), (7, 2, 800.00), (7, 3, 800.00),
  (8, 1, 1500.00), (8, 2, 500.00), (8, 3, 500.00),
  (9, 1, 1500.00), (9, 2, 1000.00), (9, 3, 1000.00),
  (10, 1, 1500.00), (10, 2, 1000.00), (10, 3, 1000.00),
  (11, 1, 1500.00), (11, 2, 800.00), (11, 3, 800.00),
  (12, 1, 1500.00), (12, 2, 500.00), (12, 3, 500.00),
  (13, 1, 1500.00), (13, 2, 1000.00), (13, 3, 1000.00),
  (14, 1, 1500.00), (14, 2, 800.00), (14, 3, 800.00),
  (15, 1, 1500.00), (15, 2, 500.00), (15, 3, 500.00),
  (16, 1, 1500.00), (16, 2, 1000.00), (16, 3, 1000.00),
  (17, 1, 1500.00), (17, 2, 1000.00), (17, 3, 1000.00),
  (18, 1, 1500.00), (18, 2, 1000.00), (18, 3, 1000.00);


-- Employee Position
INSERT INTO employee_position (employee_id, position_id, dept_id, basic_salary, effective_date) VALUES
   ('10001', 1, 3, 90000.00, '2027-01-01'),
   ('10002', 2, 3, 60000.00, '2027-01-01'),
   ('10003', 3, 4, 60000.00, '2027-01-01'),
   ('10004', 4, 7, 60000.00, '2027-01-01'),
   ('10005', 5, 6, 52670.00, '2027-01-01'),
   ('10006', 6, 5, 52670.00, '2027-01-01'),
   ('10007', 7, 5, 42975.00, '2027-01-01'),
   ('10008', 8, 5, 22500.00, '2027-01-01'),
   ('10009', 8, 5, 22500.00, '2027-01-01'),
   ('10010', 9, 4, 52670.00, '2027-01-01'),
   ('10011', 10, 4, 50825.00, '2027-01-01'),
   ('10012', 11, 4, 38475.00, '2027-01-01'),
   ('10013', 12, 4, 24000.00, '2027-01-01'),
   ('10014', 12, 4, 24000.00, '2027-01-01'),
   ('10015', 13, 1, 53500.00, '2027-01-01'),
   ('10016', 14, 1, 42975.00, '2027-01-01'),
   ('10017', 14, 1, 41850.00, '2027-01-01'),
   ('10018', 15, 1, 22500.00, '2027-01-01'),
   ('10019', 15, 1, 22500.00, '2027-01-01'),
   ('10020', 15, 1, 23250.00, '2027-01-01'),
   ('10021', 15, 1, 23250.00, '2027-01-01'),
   ('10022', 15, 1, 24000.00, '2027-01-01'),
   ('10023', 15, 1, 22500.00, '2027-01-01'),
   ('10024', 15, 1, 22500.00, '2027-01-01'),
   ('10025', 15, 1, 24000.00, '2027-01-01'),
   ('10026', 15, 1, 24750.00, '2027-01-01'),
   ('10027', 15, 1, 24750.00, '2027-01-01'),
   ('10028', 15, 1, 24000.00, '2027-01-01'),
   ('10029', 15, 1, 22500.00, '2027-01-01'),
   ('10030', 15, 1, 22500.00, '2027-01-01'),
   ('10031', 15, 1, 22500.00, '2027-01-01'),
   ('10032', 16, 7, 52670.00, '2027-01-01'),
   ('10033', 17, 8, 52670.00, '2027-01-01'),
   ('10034', 18, 2, 52670.00, '2027-01-01');