# Employee Payslip Database Report

## MotorPH HRIS and Payroll System

### Project Overview

#### Purpose

The purpose of this project is to develop an Employee Payslip Database Report for the MotorPH Human Resource Information System (HRIS) and Payroll System using advanced SQL techniques in MySQL. The report consolidates payroll and attendance data into a structured employee payslip that supports payroll processing, validation, and reporting requirements.

The system was implemented using the following technologies:

- **MySQL** as the database management system
- **Aiven Cloud MySQL** for database hosting and deployment
- **DBeaver** for database administration and SQL development
- **MySQL Shell (mysqlsh)** for script execution and database initialization
- **Python ETL scripts** for data extraction, transformation, and loading processes

#### System Scope

The Employee Payslip Report includes the following information:

- Employee identification details
- Position and department information
- Payroll period coverage
- Attendance summaries
- Earnings computation
- Benefits calculation
- Mandatory deductions
- Net pay (take-home pay) computation

The report follows MotorPH’s **bi-monthly payroll processing schedule**.

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
```

###### User Account

![User Account Init](https://drive.google.com/uc?export=view&id=1U_PzgHQfJvJO36LVXFLb2o4WEIPEVsb6)

---

### Employee Payslip Report Design

#### Payslip Data Requirements

The report design was based on the standard MotorPH employee payslip format. The following data elements were identified as necessary components of the report.

| Payslip Component    | Source Table      |
| -------------------- | ----------------- |
| Employee Information | employee          |
| Position Assignment  | employee_position |
| Job Position         | job_position      |
| Department           | department        |
| Attendance Records   | attendance_record |
| Employee Benefits    | employee_staging  |

#### SQL Techniques Applied

The report implementation utilized several advanced SQL concepts, including:

- SQL Views
- INNER JOIN
- LEFT JOIN
- Aggregate Functions
  - COUNT()
  - MIN()
  - MAX()

- String concatenation using CONCAT()
- NULL value handling using COALESCE()
- Arithmetic expressions for payroll computations
- Date filtering using BETWEEN
- Data aggregation for attendance and payroll summaries

---

### Employee Payslip View Implementation

The Employee Payslip Report was implemented through a database view named:

```sql
vw_employee_payslip
```

#### Business Rules Implemented

##### Payroll Cutoff Period

The report follows MotorPH’s bi-monthly payroll schedule.

For the second payroll cutoff period, attendance records are filtered within:

**December 16, 2024 to December 31, 2024**

```sql
WHERE ar.attendance_date
BETWEEN '2024-12-16'
AND '2024-12-31'
```

##### Gross Income Calculation

Gross income is calculated using the following formula:

```text
Daily Rate × Days Worked
```

##### Benefits Calculation

The following employee benefits are included:

- Rice Subsidy
- Phone Allowance
- Clothing Allowance

##### Mandatory Deductions

The following statutory deductions are applied:

- Social Security System (SSS)
- PhilHealth
- Pag-IBIG Fund
- Withholding Tax

##### Net Pay Calculation

Take-home pay is computed as:

```text
Gross Income
+ Total Benefits
− Total Deductions
```

**Screenshot Requirement (to be included)**

Capture a screenshot showing the execution of the payslip view creation script:

```sql
source dpa_reports/01_employee_payslip_view.sql;
```

## ![Payslip View](https://drive.google.com/uc?export=view&id=10_NTll-BAmaUfJIElJPche4ufK-1zY3a)

### Database Testing

Comprehensive testing was performed to verify the correctness and accuracy of the Employee Payslip Report.

#### View Verification

The following query was executed to confirm successful creation of the payslip view:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
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
SELECT *
FROM vw_employee_payslip
WHERE employee_id = '10015';
```

#### Validation Results

The output confirmed successful generation of:

- Payroll period information
- Attendance summaries
- Gross income calculations
- Benefit computations
- Deduction calculations
- Net pay computation

---

![Payslip Report Testing - Head](https://drive.google.com/uc?export=view&id=1knOQM3oHzhBkdhjRek31QRLF2s9LyVgC)

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

**Screenshot Filename: (to be included)**
`05_testing_script.png`

#### Validation Script

```sql
source dpa_reports/03_employee_payslip_validation.sql;
```

**Purpose**

- Validate gross income calculations
- Validate benefits computations
- Validate statutory deductions
- Validate take-home pay calculations

---

![Payslip Report Validation - Head](https://drive.google.com/uc?export=view&id=1HTclewDiNiPgRctEUrTF2MnSXmbKX012)

![Payslip Report Validation - Middle](https://drive.google.com/uc?export=view&id=1aS7nG0vrutLQqxu1RO_9Rvg5BXxtZXYu)

![Payslip Report Validation - Tail](https://drive.google.com/uc?export=view&id=1Jy4EaUqNamSeiYyFXsRyCAl-5BXmmjaz)

---

### Challenges Encountered

Several challenges were encountered during implementation:

1. SQL formatting issues caused by hidden markdown characters and escaped symbols.
2. Initial view aggregation included attendance records outside the intended payroll period.
3. Payroll computations required adaptation to the organization's bi-monthly payroll structure.

#### Resolutions Implemented

These challenges were addressed through:

- SQL syntax corrections and validation
- View redesign and query optimization
- Implementation of payroll-period filtering using the BETWEEN operator

---

### Conclusion

The Employee Payslip Database Report was successfully developed and implemented using MySQL views and advanced SQL techniques.

The solution integrates employee, attendance, payroll, and benefits data into a consolidated payslip report that supports payroll processing and reporting requirements. The implementation of a bi-monthly payroll cutoff ensures alignment with real-world payroll practices.

This project demonstrates the effective application of SQL joins, data aggregation, calculations, and reporting logic within a Human Resource Information System (HRIS) and Payroll Management environment.
