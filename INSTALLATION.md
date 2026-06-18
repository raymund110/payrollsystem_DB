# Environment Setup and Installation Guide

## MotorPH HRIS & Payroll System

### Purpose

This guide explains how to reproduce the MotorPH HRIS & Payroll System from scratch on:

- Windows 10/11
- macOS
- Linux (Ubuntu/Debian)

The setup includes:

- MySQL database installation
- Python environment configuration
- Database deployment
- ETL execution
- Payslip report generation
- Validation and testing

---

# Table of Contents

- [Purpose](#purpose)
- [1. Technology Stack](#1-technology-stack)
- [2. Project Structure](#2-project-structure)
- [3. Install Required Software](#3-install-required-software)
  - [Git](#git)
  - [Python 3.11+](#python-311)
  - [MySQL Server 8.0+](#mysql-server-80)
  - [MySQL Shell (Required)](#mysql-shell-required)
  - [Database Management Tool (Choose One)](#database-management-tool-choose-one)
    - [Option A: MySQL Workbench](#option-a-mysql-workbench)
    - [Option B: DBeaver Community Edition](#option-b-dbeaver-community-edition)

- [4. Clone the Project](#4-clone-the-project)
- [5. Configure Python Environment](#5-configure-python-environment)
- [6. Configure Database Connection](#6-configure-database-connection)
- [7. Deploy Database Schema](#7-deploy-database-schema)
- [8. Load Seed Data](#8-load-seed-data)
- [9. Create Staging Tables](#9-create-staging-tables)
- [10. Execute ETL Process](#10-execute-etl-process)
- [11. Create Payslip Report View](#11-create-payslip-report-view)
- [12. Run Validation Scripts](#12-run-validation-scripts)
- [13. Generate a Sample Payslip](#13-generate-a-sample-payslip)
- [14. Connect Using MySQL Workbench or DBeaver](#14-connect-using-mysql-workbench-or-dbeaver)
- [15. Optional Cloud Deployment (Aiven)](#15-optional-cloud-deployment-aiven)
- [Troubleshooting](#troubleshooting)
  - [mysqlsh Not Found](#mysqlsh-not-found)
  - [Python Module Not Found](#python-module-not-found)
  - [Access Denied for User](#access-denied-for-user)
  - [Payslip View Returns No Records](#payslip-view-returns-no-records)

---

# 1. Technology Stack

| Component                     | Purpose                 |
| ----------------------------- | ----------------------- |
| MySQL Server 8.0+             | Database Engine         |
| MySQL Shell (mysqlsh)         | SQL Script Execution    |
| MySQL Workbench or DBeaver CE | Database Administration |
| Python 3.11+                  | ETL Processing          |
| Pandas                        | Data Transformation     |
| SQLAlchemy                    | Database Connectivity   |
| mysql-connector-python        | MySQL Driver            |
| Git                           | Source Control          |
| Aiven MySQL (Optional)        | Cloud Deployment        |

---

# 2. Project Structure

```text
MotorPH-HRIS/
├── dpa_schema/
├── dpa_seed/
├── dpa_etl/
├── dpa_reports/
├── python/
├── data/
├── screenshots/
├── requirements.txt
├── .env.example
└── README.md
```

---

# 3. Install Required Software

## Git

### Windows

Download and install Git from:
https://git-scm.com/download/win

### macOS

```bash
brew install git
```

### Linux

```bash
sudo apt install git -y
```

Verify:

```bash
git --version
```

---

## Python 3.11+

### Windows

Download from:
https://www.python.org/downloads/

> Ensure **Add Python to PATH** is selected during installation.

### macOS

```bash
brew install python
```

### Linux

```bash
sudo apt install python3 python3-pip python3-venv -y
```

Verify:

```bash
python --version
```

or

```bash
python3 --version
```

---

## MySQL Server 8.0+

### Windows

Download:
https://dev.mysql.com/downloads/mysql/

### macOS

```bash
brew install mysql
brew services start mysql
```

### Linux

```bash
sudo apt install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql
```

Verify:

```bash
mysql --version
```

---

## MySQL Shell (Required)

### Windows

Download:
https://dev.mysql.com/downloads/shell/

### macOS

```bash
brew install mysql-shell
```

### Linux

```bash
sudo apt install mysql-shell
```

Verify:

```bash
mysqlsh --version
```

---

## Database Management Tool (Choose One)

### Option A: MySQL Workbench

Official MySQL GUI for database administration.

Windows:
https://dev.mysql.com/downloads/workbench/

macOS:

```bash
brew install --cask mysqlworkbench
```

Linux:

```bash
sudo apt install mysql-workbench -y
```

### Option B: DBeaver Community Edition

Cross-platform database management tool.

Download:
https://dbeaver.io/download/

> Either MySQL Workbench or DBeaver can be used for database inspection, validation, and report testing.

---

# 4. Clone the Project

```bash
git clone https://github.com/<organization>/motorph-hris.git
cd motorph-hris
```

---

# 5. Configure Python Environment

### Windows

```powershell
python -m venv venv
venv\Scripts\activate
```

### macOS/Linux

```bash
python3 -m venv venv
source venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Required packages:

```text
pandas
sqlalchemy
mysql-connector-python
python-dotenv
```

---

# 6. Configure Database Connection

Create a `.env` file in the project root:

```env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=motorph
DB_USER=root
DB_PASSWORD=<your_password>
```

---

# 7. Deploy Database Schema

Open MySQL Shell:

```bash
mysqlsh root@localhost
```

Switch to SQL mode:

```sql
\sql
```

Execute the schema scripts:

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

Verify:

```sql
SHOW DATABASES;
```

Expected:

```text
motorph
```

---

# 8. Load Seed Data

```sql
source dpa_seed/00_department_seed.sql;
source dpa_seed/01_positions_seed.sql;
source dpa_seed/02_roles_seed.sql;
source dpa_seed/03_permissions_seed.sql;
source dpa_seed/04_role_permission_seed.sql;
source dpa_seed/05_user_accounts_seed.sql;
```

Verify:

```sql
SELECT COUNT(*) FROM department;
```

---

# 9. Create Staging Tables

```sql
source dpa_etl/00_employee_staging.sql;
source dpa_etl/01_attendance_staging.sql;
```

---

# 10. Execute ETL Process

Run the ETL scripts:

```bash
python python/load_employee_staging.py
python python/transform_employee.py

python python/load_attendance_staging.py
python python/transform_attendance.py
```

Expected:

```text
Employee records loaded
Attendance records loaded
Transformation completed
```

---

# 11. Create Payslip Report View

```sql
source dpa_reports/01_employee_payslip_view.sql;
```

Verify:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

Expected:

```text
vw_employee_payslip
```

---

# 12. Run Validation Scripts

```sql
source dpa_reports/02_employee_payslip_test.sql;
source dpa_reports/03_employee_payslip_validation.sql;
```

---

# 13. Generate a Sample Payslip

```sql
SELECT *
FROM vw_employee_payslip
WHERE employee_id = '10015';
```

Expected output:

```text
Employee Name
Department
Position
Payroll Period
Gross Income
Benefits
Deductions
Net Pay
```

---

# 14. Connect Using MySQL Workbench or DBeaver

Create a MySQL connection using:

```text
Host: localhost
Port: 3306
Database: motorph
Username: root
Password: <your_password>
```

Test the connection and verify that:

- Tables are visible
- Seed data exists
- `vw_employee_payslip` is available
- Queries execute successfully

---

# 15. Optional Cloud Deployment (Aiven)

To reproduce the cloud deployment:

1. Create an Aiven MySQL instance.
2. Download the SSL certificates.
3. Update the `.env` configuration.
4. Configure Python to use SSL connections.
5. Execute the same schema, seed, ETL, and report scripts against the Aiven database.

---

# Troubleshooting

### mysqlsh Not Found

Verify installation:

```bash
mysqlsh --version
```

If unavailable:

- Windows: Add MySQL Shell to the system PATH.
- macOS: `brew install mysql-shell`
- Linux: `sudo apt install mysql-shell`

---

### Python Module Not Found

```bash
pip install -r requirements.txt
```

---

### Access Denied for User

Verify MySQL credentials and update the `.env` file accordingly.

---

### Payslip View Returns No Records

Verify attendance data exists:

```sql
SELECT *
FROM attendance_record
LIMIT 10;
```

Also confirm that attendance dates fall within the payroll cutoff period defined in `vw_employee_payslip`.
