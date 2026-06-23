# Employee Payslip Database Report

## MotorPH HRIS and Payroll System

### Project Overview

#### Purpose

The objective of this project is to implement database-driven payroll reporting for the **MotorPH HRIS and Payroll System** using **MySQL**, advanced SQL reporting techniques, and ETL-based data transformation.

The project consists of two major payroll reporting components:

### 1. Employee Payslip Report

Generates an individual employee payslip for a specific semi-monthly payroll period.

### 2. Payroll Summary Report

Generates a consolidated payroll report for multiple employees for a monthly reporting period.

The system integrates employee data, attendance records, compensation information, statutory deductions, and tax computations to generate accurate payroll reports.

#### Technologies Used

- **MySQL** — Primary database engine
- **DBeaver** — Database management and SQL development
- **mysqlsh** — SQL script execution
- **Python** — ETL scripts and data transformation
- **Aiven Cloud MySQL** — Cloud database deployment

---

#### System Architecture

The system follows a layered architecture:

#### Data Source Layer

Raw employee and attendance records.

Examples:

- Employee master records
- Attendance logs
- Payroll-related reference data

---

#### Staging Layer

Temporary raw data ingestion tables.

Tables:

- `employee_staging`
- `attendance_staging`

Purpose:

- Load raw CSV/source data
- Prepare data for transformation

---

#### Core Database Layer

Normalized HRIS and payroll schema.

Key tables:

- `employee`
- `employee_position`
- `department`
- `job_position`
- `attendance_record`

Reference tables:

- `sss_contribution_bracket`
- `philhealth_contribution_rule`
- `pagibig_contribution_rule`
- `withholding_tax_bracket`

---

#### Reporting Layer

SQL views used for payroll reporting.

Employee Payslip:

- `vw_employee_payslip`

Payroll Summary:

- `vw_payroll_core`
- `vw_payroll_summary`

---

### Database Environment Setup

#### DB Connection with mysqlsh

![DB connection with mysqlsh](https://drive.google.com/uc?export=view&id=1F1xeaIE7xyWtqQgP9Sy4zCjTktLCmnY_)

#### Database Implementation Process

The MotorPH payroll database was initialized through a series of structured SQL scripts executed using MySQL Shell.

##### Schema Creation

```sql
source dpa_schema/01_database.sql;
source dpa_schema/02_lookup_tables.sql;
source dpa_schema/03_employee_tables.sql;
source dpa_schema/04_rbac_tables.sql;
source dpa_schema/05_leave_tables.sql;
source dpa_schema/06_attendance_tables.sql;
source dpa_schema/07_payroll_tables.sql;
source dpa_schema/08_indexes.sql;
```

##### DROP DB & Schema Creation (Head)

![Schema Creation - Head](https://drive.google.com/uc?export=view&id=1e9u2Ad6R4gKcyPtKAA1lEpHJuw52X8VM)

---

##### Schema Creation (Tail)

![Schema Creation - Tail](https://drive.google.com/uc?export=view&id=1V1-q1vJ2AMJucYo7MPOOLRRpkElo5AZL)

##### Seed Data Initialization

```sql
source dpa_seed/00_department_seed.sql;
source dpa_seed/01_positions_seed.sql;
source dpa_seed/02_roles_seed.sql;
source dpa_seed/03_permissions_seed.sql;
source dpa_seed/04_role_permission_seed.sql;
```

##### Data Seeding

![Data Seeding](https://drive.google.com/uc?export=view&id=1xI76O9y17FWONL1NLnCAd0F5M5DWw_87)

##### ETL Staging Setup

```sql
source dpa_etl/00_employee_staging.sql;
source dpa_etl/01_attendance_staging.sql;
```

###### ETL Staging

![ETL Staging](https://drive.google.com/uc?export=view&id=1V1ohN0ihup0WnlgrIWCODFbP66aKNHhs)

##### Python ETL Processing

```bash
python python/load_employee_staging.py
python python/transform_employee.py
python python/load_attendance_staging.py
python python/transform_attendance.py
```

###### ETL Processing

![ETL Processing](https://drive.google.com/uc?export=view&id=1ExFmTT03BN7dNgB7Zf13Vm6KeTSxZSsa)

##### User Account Initialization

```sql
source dpa_seed/05_user_accounts_seed.sql;
source dpa_seed/06_withholding_tax_seed.sql;
source dpa_seed/07_statutory_contribution_seed.sql
```

###### User Account

![User Account Init](https://drive.google.com/uc?export=view&id=1U_PzgHQfJvJO36LVXFLb2o4WEIPEVsb6)

---

### Employee Payslip Report Design

After running all the SQL and Python scripts in sequence, the DB can generate the view for payslip reporting by running the following SQL scripts for reporing also in sequence. It provides the actual payslip report, testing and validation.

```sql
-- # Run in sequence

-- # actuall report generation
source dpa_reports/01_employee_payslip_view.sql;

-- # test methods
source dpa_reports/02_employee_payslip_test.sql;

--- # validation of result
source dpa_reports/03_employee_payslip_validation.sql;

```

---

Employee Payslip Database Report

---

## Purpose

The Employee Payslip Report generates payroll details for an individual employee during a semi-monthly payroll period.

---

## SQL Files

```text
dpa_reports/01_employee_payslip_view.sql
dpa_reports/02_employee_payslip_test.sql
dpa_reports/03_employee_payslip_validation.sql
```

---

## Report Data Requirements

The report includes:

- Employee ID
- Employee Name
- Position
- Department
- Payroll Period
- Gross Income
- Benefits
- Deductions
- Taxable Income
- Take Home Pay

---

#### Employee Payslip Business Rules

---

##### Payroll Frequency

Semi-monthly.

Example payroll periods:

- December 1–15, 2024
- December 16–31, 2024

Sample payroll period used:

```sql
WITH payroll_period AS (
    SELECT
        '2024-12-01' AS period_start,
        '2024-12-15' AS period_end
)
```

The payroll period can be modified during demonstrations or presentations.

---

##### Attendance Filtering

Attendance records are filtered by payroll cutoff period.

```sql
WHERE attendance_date BETWEEN period_start AND period_end
```

---

#### Daily Rate Formula

Daily rate uses a 22-working-day basis.

```text
Daily Rate = Monthly Salary ÷ 22
```

This aligns more closely with realistic payroll computation than a 20-day basis.

---

#### Gross Income Formula

Payslip computation is attendance-driven.

```text
Gross Income = Daily Rate × Days Worked
```

---

#### Benefits

Benefits are sourced from:

- `employee_staging`

Included benefits:

- Rice Subsidy
- Phone Allowance
- Clothing Allowance

Since payslip is semi-monthly, benefits are divided by two.

```text
Bi-monthly Benefit = Monthly Benefit ÷ 2
```

---

#### Statutory Deductions

The system computes:

- SSS
- PhilHealth
- Pag-IBIG

These are calculated using table-driven deduction rules.

---

#### Taxable Income Formula

```text
Taxable Income =
Gross Income
+ Total Benefits
− Statutory Deductions
```

---

#### Withholding Tax Formula

Tax is computed using table-driven tax brackets.

Formula:

```text
Withholding Tax =
Base Tax + ((Taxable Income − Minimum Salary) × Excess Rate)
```

Source table:

- `withholding_tax_bracket`

---

#### Take Home Pay Formula

```text
Take Home Pay =
Gross Income
+ Benefits
− Total Deductions
```

---

#### Employee Payslip SQL Techniques Used

The implementation uses advanced SQL techniques:

- SQL Views
- CTEs
- INNER JOIN
- LEFT JOIN
- Aggregation
- COUNT()
- SUM()
- ROUND()
- COALESCE()
- Arithmetic Expressions
- Payroll Cutoff Filtering

---

📸 Screenshot Required
Show successful execution of:

```sql
source dpa_reports/01_employee_payslip_view.sql;
```

Suggested filename:
`02_view_creation.png`

---

#### Employee Payslip Testing and Validation

---

##### View Verification

```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

Expected:

- `vw_employee_payslip`

---

##### Sample Payslip Test

```sql
SELECT *
FROM vw_employee_payslip
WHERE employee_id = '10015';
```

Validates:

- Attendance aggregation
- Payroll computation
- Benefits
- Deductions
- Take-home pay

---

##### Testing Script

```sql
source dpa_reports/02_employee_payslip_test.sql;
```

##### Validation Script

```sql
source dpa_reports/03_employee_payslip_validation.sql;
```

Validates:

- Gross income
- Benefits
- Deductions
- Tax
- Net pay

---

###### Payslip View Creation

![Payslip View](https://drive.google.com/uc?export=view&id=10_NTll-BAmaUfJIElJPche4ufK-1zY3a)

### Database Testing

Comprehensive testing was performed to verify the correctness and accuracy of the Employee Payslip Report.

#### View Verification

The following query was executed to confirm successful creation of the payslip view:

```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

**Expected Result:**

```text
vw_employee_payslip
```

#### Sample Payslip Testing

The report was tested using the following employee record:

**Employee ID:** 10015
**Employee Name:** Fredrick Romualdez

Test query:

```sql
-- # Run this SQL script to test
SELECT * FROM vw_employee_payslip WHERE employee_id='10015';
```

#### Validation Results

The output confirmed successful generation of:

- Payroll period information
- Attendance summaries
- Gross income calculations
- Benefit computations
- Deduction calculations
- Net pay computation

###### Payroll Report Testing (Head)

![Payslip Report Testing - Head](https://drive.google.com/uc?export=view&id=1knOQM3oHzhBkdhjRek31QRLF2s9LyVgC)

###### Payroll Report Testing (Tail)

![Payslip Report Testing - Head](https://drive.google.com/uc?export=view&id=18myA49k-P6kcAbVW_Aa0nwUnjuJTGkEG)

---

### Payroll Validation

Additional validation procedures were performed to verify payroll accuracy.

#### Testing Script

```sql
source dpa_reports/02_employee_payslip_test.sql;
```

**Purpose**

- Verify view creation
- Display sample report output
- Test employee payslip generation

#### Validation Script

```sql
source dpa_reports/03_employee_payslip_validation.sql;
```

**Purpose**

- Validate gross income calculations
- Validate benefits computations
- Validate statutory deductions
- Validate take-home pay calculations

###### Payslip Report Validation (Head)

![Payslip Report Validation - Head](https://drive.google.com/uc?export=view&id=1HTclewDiNiPgRctEUrTF2MnSXmbKX012)

###### Payroll Report Validation (Middle)

![Payslip Report Validation - Middle](https://drive.google.com/uc?export=view&id=1aS7nG0vrutLQqxu1RO_9Rvg5BXxtZXYu)

###### Payroll Report Validation (Tail)

![Payslip Report Validation - Tail](https://drive.google.com/uc?export=view&id=1Jy4EaUqNamSeiYyFXsRyCAl-5BXmmjaz)

###### Revised Payslip Report View

![Payslip Report with Withholding Tax Computation](https://drive.google.com/uc?export=view&id=1kum6auIWkdQwZ0A8pUEI-0Z0Bwy-vEBc)

---

### Payroll Summary Database Report

```sql
-- # Run in sequence

-- # reusable payroll base view
source dpa_reports/04_payroll_core_view.sql;

-- # final payroll summary report
source dpa_reports/05_payroll_summary_view.sql;

--- # validation/testing
source dpa_reports/06_payroll_summary_test.sql;

```

#### Purpose

The Payroll Summary Report provides a consolidated payroll overview for multiple employees over a monthly reporting period.

Unlike the payslip report, this report focuses on summary-level payroll reporting.

---

##### SQL Files

```text
dpa_reports/04_payroll_core_view.sql
dpa_reports/05_payroll_summary_view.sql
dpa_reports/06_payroll_summary_test.sql
```

---

##### Report Period

Monthly.

Sample reporting period:

```text
December 1–31, 2024
```

---

#### Payroll Summary Business Rules

---

##### Employee Coverage

Only employees with attendance records during the reporting month are included.

---

##### Gross Income Rule

Payroll Summary uses salary-based gross income.

```text
Gross Income = Monthly Salary
```

This differs from the Employee Payslip Report.

Reason:

- Payslip = operational transaction report
- Payroll Summary = management reporting report

---

##### Benefits Handling

Benefits are included in payroll computation logic but are not displayed as separate columns in the summary report.

---

##### Summary Report Columns

The output follows the sample MotorPH Payroll Summary Report.

Columns:

- Employee No
- Employee Full Name
- Position
- Department
- Gross Income
- SSS Number
- SSS Contribution
- PhilHealth Number
- PhilHealth Contribution
- Pag-IBIG Number
- Pag-IBIG Contribution
- TIN
- Withholding Tax
- Net Pay

---

#### Payroll Summary SQL Design

---

##### Core View

`vw_payroll_core`

Purpose:

- Aggregate payroll data
- Compute statutory deductions
- Compute withholding tax
- Compute net pay

---

##### Summary View

`vw_payroll_summary`

Purpose:

- Present final reporting format

Example:

```sql
SELECT
    employee_no,
    employee_name,
    position_name,
    department_name,
    gross_income,
    sss_number,
    sss_contribution,
    philhealth_number,
    philhealth_contribution,
    pagibig_number,
    pagibig_contribution,
    tin_number,
    withholding_tax,
    net_pay
FROM vw_payroll_core;
```

---

#### Payroll Summary Testing

Testing validates:

- Employee inclusion
- Monthly gross pay
- Deduction computations
- Net pay accuracy
- Multi-employee reporting

---

Suggested validation queries:

```sql
SELECT * FROM vw_payroll_core;
SELECT * FROM vw_payroll_summary;
```

### Conclusion

The MotorPH HRIS and Payroll reporting system was successfully implemented using MySQL, Python ETL, and advanced SQL reporting techniques.

The project demonstrates practical implementation of:

- Database schema design
- ETL workflows
- Payroll computation logic
- Statutory deduction calculation
- SQL reporting
- Database testing and validation
