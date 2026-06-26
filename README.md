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
- DBeaver
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

# Setup and Execution

Run scripts in order (at the project root).

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
pip install -r requirements.txt
```

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

## 6. Payslip Report

```sh
\source dpa_reports/payslip.sql
```

---

## 7. Payroll Summary Report

```sh
\source dpa_reports/payroll.sql
```

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

---

# Submission Note

This project cannot be properly evaluated using a single SQL file.

It requires:

- SQL schema scripts
- SQL seed scripts
- Python ETL scripts
- Reporting views
- Validation scripts

For proper evaluation, please use the full repository or project ZIP.