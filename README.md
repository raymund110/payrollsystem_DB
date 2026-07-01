# MotorPH HRIS & Payroll Reporting

## Overview

This project implements a database-driven HRIS and payroll reporting system for MotorPH using MySQL and Python ETL.

The project generates two reports:

- Employee Payslip Report (semi-monthly)
- Payroll Summary Report (monthly)

This implementation goes beyond a single SQL report because payroll reporting requires:

- database schema setup
- seed/reference data
- ETL processing
- reporting views
- validation scripts

Because of this, the project is delivered as a modular SQL + Python pipeline.

---

## Tech Stack

- MySQL
- mysqlsh
- Python
- DBeaver/MYSQL Workbench
- Aiven Cloud MySQL

---

## Project Structure

```text
dpa_schema/    → Database schema
dpa_seed/      → Seed/reference data
dpa_etl/       → Staging SQL
python/        → ETL scripts
dpa_reports/   → Report views + tests + validation
```

---

## Architecture

```text
Source Data
   ↓
Python ETL
   ↓
MySQL Database
   ↓
SQL Reporting Views
   ↓
Validation Scripts
```

---

## Key Business Rules

### Employee Payslip

- Semi-monthly payroll
- Attendance-driven
- Gross Income = Daily Rate × Days Worked

Views:

- `vw_employee_payslip`

---

### Payroll Summary

- Monthly payroll period
- Attendance-driven
- Consolidated multi-employee reporting

Views:

- `vw_payroll_core`
- `vw_payroll_summary`

---

## Configuration-Driven Payroll Rules

Payroll computations are configuration-driven using database tables.

Reference tables:

- `sss_contribution_bracket`
- `philhealth_contribution_rule`
- `pagibig_contribution_rule`
- `withholding_tax_bracket`
- `payroll_period_config`

This means payroll rules are not hardcoded in SQL views.

---

## Environment Setup

This project uses environment variables for Python ETL database connectivity.

Before running the ETL scripts, create a `.env` file in the project root based on `.env.example`.

Example:

```bash
cp .env.example .env
```

Configure the following values based on your MySQL environment:

```env
DB_HOST=your_mysql_host
DB_USER=your_mysql_user
DB_PASSWORD=your_mysql_password
DB_NAME=payrollsystem_db
DB_PORT=3306
```

Example for local MySQL:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=payrollsystem_db
DB_PORT=3306
```

---

# Setup and Execution

> Important: Execute SQL scripts using mysqlsh (SQL mode) from the project root directory so relative paths work correctly. Commands are case sensitive

## 1. Schema Setup

```sh
\source dpa_schema/install_all.sql
```

---

## 2. Initial Seed Data

```sh
\source dpa_seed/init.sql
```

---

## 3. ETL Setup

```sh
\source dpa_etl/init.sql
```

---

## 4. Python ETL

Install requirements:

```bash
# be sure to activate your Python virtual environment before installation
pip install -r requirements.txt
```

> Important: Execute Python scripts from the project root directory so relative paths work correctly

Run ETL:

```bash
python python/load_employee_staging.py
python python/transform_employee.py
python python/load_attendance_staging.py
python python/transform_attendance.py
```

---

## 5. Final Seed Scripts

```sh
\source dpa_seed/finalize.sql
```

---

## 6. Payslip Report with Validation

```sh
\source dpa_reports/payslip.sql
```

### Snapshot

#### Payslip View with Validation (Nov. 1-15, 2024, First Cut-Off)

[![Payslip View with Validation](https://drive.google.com/uc?export=view&id=1-UQy6mNv8gnuQ6THULgak478L1xH0Orf)](https://drive.google.com/file/d/1-UQy6mNv8gnuQ6THULgak478L1xH0Orf/view?usp=sharing)

[![Payslip View with Validation](https://drive.google.com/uc?export=view&id=1fRvgoRw0QeiF3YzjbobVBd8vvnA6e6l9)](https://drive.google.com/file/d/1fRvgoRw0QeiF3YzjbobVBd8vvnA6e6l9/view?usp=sharing)

#### Payslip View with Validation (Nov. 16-30, 2024, Second Cut-Off)

[![Payslip View with Validation](https://drive.google.com/uc?export=view&id=1yC9ef_Kd28Hh1OBkjirSUR_MTydvc8_h)](https://drive.google.com/file/d/1yC9ef_Kd28Hh1OBkjirSUR_MTydvc8_h/view?usp=sharing)

[![Payslip View with Validation](https://drive.google.com/uc?export=view&id=10Y7K2GO1kmCAR0My7CNVQPqB0odNNmIC)](https://drive.google.com/file/d/10Y7K2GO1kmCAR0My7CNVQPqB0odNNmIC/view?usp=sharing)

---

## 7. Payroll Summary Report with Validation

```sh
\source dpa_reports/payroll.sql
```

### Snapshot

#### Payroll View with Validation (November 2024)

[![Payroll View with Validation](https://drive.google.com/uc?export=view&id=1fewnw0_fOdXJNMrKqeBPXT-h-cqmZlWe)](https://drive.google.com/file/d/1fewnw0_fOdXJNMrKqeBPXT-h-cqmZlWe/view?usp=sharing)

[![Payroll View](https://drive.google.com/uc?export=view&id=1Cp3rrFsXieV17N42jQv-KsLxZmZn0UlK)](https://drive.google.com/file/d/1Cp3rrFsXieV17N42jQv-KsLxZmZn0UlK/view?usp=sharing)

---

## 8. Changing Payslip Cut-Off and Monthly Payroll Period

```sql
-- # cut-off change
source dpa_reports/change_cutoff.sql

-- # payroll period change by month and year
source dpa_reports/change_payroll_month.sql
```

### Snapshot

[![Payslip Change](https://drive.google.com/uc?export=view&id=1P_zr8MACkCT5Ds5eY_M8NluT4c170BeS)](https://drive.google.com/file/d/1P_zr8MACkCT5Ds5eY_M8NluT4c170BeS/view?usp=sharing)

[![Changed Payroll to Decemver 2025](https://drive.google.com/uc?export=view&id=1ZqRaGD92IVSSCoYu07rBXG9WrDV0m4zy)](https://drive.google.com/file/d/1ZqRaGD92IVSSCoYu07rBXG9WrDV0m4zy/view?usp=sharing)

---

# Validation

Validation scripts produce PASS/FAIL outputs.

Examples:

- Gross income validation
- Deduction validation
- Net pay validation
- Non-negative validation

Example:

```text
NET PAY VALIDATION      PASS
DEDUCTIONS VALIDATION   PASS
NON-NEGATIVE VALIDATION PASS
```

### Snaphot

#### Payslip Validation (November 1-15, 2024, First Cut-Off)

[![Payslip Validation First Cut-Off](https://drive.google.com/uc?export=view&id=1GLRP1tc6HFpbb_il089NnMLNVJEuGc5_)](https://drive.google.com/file/d/1GLRP1tc6HFpbb_il089NnMLNVJEuGc5_/view?usp=sharing)

#### Payslip Validation (November 16-30, 2024, Second Cut-Off)

[![Payslip Validation Second Cut-Off](https://drive.google.com/uc?export=view&id=16Ot8D0zxvVPqGZHQTLvA2Jy6ihCbGlrM)](https://drive.google.com/file/d/16Ot8D0zxvVPqGZHQTLvA2Jy6ihCbGlrM/view?usp=sharing)

#### Payroll Validation (November 2024)

[![Payroll Summary Validation](https://drive.google.com/uc?export=view&id=1uKnwaUJpSLDCrNqODamI_8AGOI1hk0X-)](https://drive.google.com/file/d/1uKnwaUJpSLDCrNqODamI_8AGOI1hk0X-/view?usp=sharing)

[![Payroll Totals Validation](https://drive.google.com/uc?export=view&id=1KxEjCfrZawUGBYOJNNwWEDhsyGojPm-y)](https://drive.google.com/file/d/1KxEjCfrZawUGBYOJNNwWEDhsyGojPm-y/view?usp=sharing)

---

# HRIS & Payroll System Business Logic

## Overview

The MotorPH HRIS & Payroll System is a database-driven payroll reporting system built using MySQL and Python ETL.

The system generates two main payroll reports:

- Employee Payslip Report (Semi-Monthly)
- Payroll Summary Report (Monthly)

Payroll computation is configuration-driven using database tables for payroll periods, statutory deductions, and withholding tax rules.

---

## Payroll Processing Flow

```text
Source Data
→ Staging Tables
→ Python ETL
→ Production Database
→ Payroll Views
→ Validation Scripts
```

---

## Payroll Model

MotorPH uses an **attendance-driven payroll model** for all employees regardless of:

- Employment Type (Regular / Probationary)
- Position Level (Rank-and-File / Chief / Management)

All payroll computations are based on actual attendance records within the configured payroll period.

---

## Salary Basis

### Monthly Rate

Monthly rate refers to the employee’s official base salary stored in:

- `employee_position.basic_salary`

Formula:

```text
Monthly Rate = Basic Salary
```

---

### Daily Rate

Daily rate is derived using a fixed 22-working-day divisor.

Formula:

```text
Daily Rate = Monthly Rate / 22
```

Example:

```text
Monthly Rate = 22,000
Daily Rate = 22,000 / 22 = 1,000
```

---

## Employee Payslip Computation (Semi-Monthly)

Payslip payroll periods are configured in:

- `payroll_period_config`

where:

- `period_type = 'PAYSLIP'`

---

### Gross Income

Gross income is computed using attendance.

Formula:

```text
Gross Income = Daily Rate × Days Worked
```

Example:

```text
Daily Rate = 1,000
Days Worked = 10
Gross Income = 10,000
```

---

## Benefits and Allowances

The system supports three employee allowances:

- Rice Subsidy
- Phone Allowance
- Clothing Allowance

---

### Monthly Benefits

Formula:

```text
Monthly Benefits =
Rice Subsidy
+ Phone Allowance
+ Clothing Allowance
```

---

### Semi-Monthly Benefits

Benefits are distributed equally per cutoff.

Formula:

```text
Semi-Monthly Benefits = Monthly Benefits / 2
```

---

## Statutory Deductions

Statutory deductions are computed using database-driven configuration tables:

- `sss_contribution_bracket`
- `philhealth_contribution_rule`
- `pagibig_contribution_rule`

These deductions use the employee’s monthly salary as basis.

---

### SSS Contribution

SSS contribution is determined using salary bracket lookup.

For payslip:

```text
Semi-Monthly SSS = Monthly SSS / 2
```

---

### PhilHealth Contribution

PhilHealth is computed using:

- salary floor
- salary ceiling
- premium rate
- employee share rate

Formula:

```text
PhilHealth =
Salary Basis × Premium Rate × Employee Share
```

For payslip:

```text
Semi-Monthly PhilHealth = Monthly PhilHealth / 2
```

---

### Pag-IBIG Contribution

Pag-IBIG contribution is salary-based.

Rules:

- Salary ≤ 1,500 → 1%
- Salary > 1,500 → 2%

Formula:

```text
Pag-IBIG = Salary Basis × Employee Rate
```

For payslip:

```text
Semi-Monthly Pag-IBIG = Monthly Pag-IBIG / 2
```

---

## Taxable Income

Taxable income is used as the basis for withholding tax computation.

Formula:

```text
Monthly Taxable Income =
Monthly Rate
+ Monthly Benefits
− Monthly Statutory Deductions
```

---

## Withholding Tax

Withholding tax is computed using progressive tax brackets from:

- `withholding_tax_bracket`

Formula:

```text
Withholding Tax =
Base Tax
+ ((Taxable Income − Minimum Bracket Salary) × Excess Rate)
```

For payslip:

1. Monthly taxable income is computed.
2. Monthly withholding tax is calculated.
3. Withholding tax is split into two pay periods.

Formula:

```text
Semi-Monthly Withholding Tax =
Monthly Withholding Tax / 2
```

---

## Total Deductions

Formula:

```text
Total Deductions =
SSS
+ PhilHealth
+ Pag-IBIG
+ Withholding Tax
```

---

## Take-Home Pay (Payslip)

Formula:

```text
Take-Home Pay =
(Gross Income + Benefits)
− Total Deductions
```

---

## Payroll Summary Computation (Monthly)

Monthly payroll summary is generated using:

- `vw_payroll_core`
- `vw_payroll_summary`

Payroll periods are configured in:

- `payroll_period_config`

where:

- `period_type = 'PAYROLL'`

This report consolidates payroll information for all employees including:

- gross income
- benefits
- deductions
- taxable income
- withholding tax
- net pay

---

## Validation Rules

Validation scripts ensure payroll accuracy.

Validation checks include:

- Gross Income Validation
- Deductions Validation
- Net Pay Validation
- Non-Negative Validation

Example:

```text
NET PAY VALIDATION      PASS
DEDUCTIONS VALIDATION   PASS
NON-NEGATIVE VALIDATION PASS
```

---

## Payroll Computation Rationale

The system uses a hybrid computation basis for payroll processing.

### Earnings Computation Basis

Employee earnings are attendance-driven.

Gross income is computed using actual attendance records within the payroll period.

Formula:

```text
Gross Income = Daily Rate × Days Worked
```

This ensures employee earnings reflect actual attendance and payroll cutoff activity.

---

### Deduction Computation Basis

Statutory deductions and withholding tax are computed using the employee’s monthly salary instead of cutoff earnings.

This applies to:

- SSS
- PhilHealth
- Pag-IBIG
- Withholding Tax

Reason:

Government-mandated deductions and tax brackets are typically based on monthly compensation rather than semi-monthly attendance-based earnings.

Because of this:

- Monthly statutory deductions are computed first
- Semi-monthly payslip deductions are derived by dividing monthly deductions by 2

This ensures payroll deductions remain aligned with standard payroll practices while earnings remain attendance-sensitive.

---

### Attendance Interpretation

Attendance computation uses employee attendance records within the configured payroll period.

The system computes:

- `days_worked` = count of distinct attendance dates
- `total_hours_worked` = total rendered work hours

Current implementation uses `days_worked` as the primary basis for gross income computation.

While `hours_worked` is recorded and reported, it is currently used for monitoring and validation purposes only.

---

## System Assumptions and Limitations

System assumptions:

1. Payroll is fully attendance-driven.
2. Daily rate uses a 22-working-day divisor.
3. Payslip is computed semi-monthly.
4. Payroll summary is computed monthly.
5. Benefits are distributed equally per cutoff.
6. Statutory deductions are based on monthly salary.
7. Withholding tax uses monthly taxable income basis.

Current limitations:

- Allowances are currently sourced from staging data.
- Payroll policies are simplified based on current MotorPH requirements.
- Additional payroll features such as overtime, undertime, late deductions, and leave conversion are not yet implemented.

# Submission Note

This project cannot be properly evaluated using a single SQL file.

It requires:

- SQL schema scripts
- SQL seed scripts
- Python ETL scripts
- Reporting views
- Validation scripts

For proper evaluation, please use the full repository or project ZIP.
