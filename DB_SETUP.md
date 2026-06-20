# Project Repository, Database Setup, and Deployment Sequence

Before running the MotorPH Payroll Database system, clone the repository, configure the environment, and follow the required database initialization sequence.

---

# 1. Clone Repository

Clone the repository:

```bash
git clone git@github.com:raymund110/payrollsystem_DB.git
```

Navigate into the project:

```bash
cd payrollsystem_DB
```

---

# 2. Switch to Required Branch

This project is not currently running from the `main` branch.

Check available branches:

```bash
git branch -a
```

Locate:

```text
remotes/origin/arne/ms2-homework1
```

Switch branch:

```bash
git checkout arne/ms2-homework1
```

Verify:

```bash
git branch
```

Expected:

```text
* arnel/ms2-homework1
```

---

# 3. Keep Repository Updated

The `arnel/ms2-homework1` branch is actively updated.

Before running the project:

```bash
git fetch origin
git pull origin arne/ms2-homework1
```

Recommended:

```bash
git fetch origin && git pull origin arne/ms2-homework1
```

---

# 4. Configure Database Connection

Create a `.env` file at the project root:

```text
.env
```

Copy the structure from:

```text
.env.example
```

Add the required database credentials:

```env
DB_HOST=<database_host>
DB_PORT=<database_port>
DB_NAME=<database_name>
DB_USER=<database_user>
DB_PASSWORD=<database_password>
```

---

## Aiven MySQL Option

The project can connect to the shared Aiven MySQL instance.

Enter the provided Aiven credentials into `.env`.

Do not share:

- `.env` file
- database credentials
- SSL certificates

---

## Recommended Database Option

Using your own MySQL instance is recommended.

You may use:

- Local MySQL Server
- Personal cloud MySQL instance

Connect it using the same `.env` configuration.

This provides better control and avoids conflicts.

---

## Shared Aiven Database Warning

The provided Aiven database is shared among project members.

Avoid running destructive commands such as:

```sql
DROP DATABASE
TRUNCATE TABLE
DELETE FROM ...
```

Dropping or resetting the database may affect other users because everyone is connected to the same experimental database instance.

If you need a clean database reset:

- Create your own MySQL instance, or
- Create a separate database schema under your own account.

---

# 5. Activate Python Virtual Environment

Before running Python ETL scripts, activate the virtual environment.

If using another terminal, activate it again.

## Windows

```powershell
venv\Scripts\activate
```

## macOS/Linux

```bash
source venv/bin/activate
```

Confirm:

```bash
python --version
```

---

# 6. MotorPH Database Initialization Sequence

The database must be created in the following order.

Running scripts out of sequence may cause:

- Missing table errors
- Failed foreign key creation
- Missing staging data
- ETL failures
- Incorrect payslip reports

---

# Step 1 — Schema Creation

Open MySQL Shell:

```bash
mysqlsh root@localhost
```

Switch to SQL mode:

```sql
\sql
```

Execute:

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

---

# Step 2 — Seed Base Data

Execute:

```sql
source dpa_seed/00_department_seed.sql;

source dpa_seed/01_positions_seed.sql;

source dpa_seed/02_roles_seed.sql;

source dpa_seed/03_permissions_seed.sql;

source dpa_seed/04_role_permission_seed.sql;
```

---

# Step 3 — Create ETL Staging Tables

Execute:

```sql
source dpa_etl/00_employee_staging.sql;

source dpa_etl/01_attendance_staging.sql;
```

---

# Step 4 — Run Python ETL Processing

Open another terminal.

Ensure the Python virtual environment is activated.

Run the scripts in this exact order:

```bash
python python/load_employee_staging.py

python python/transform_employee.py

python python/load_attendance_staging.py

python python/transform_attendance.py
```

Do not change the execution order.

The Python scripts depend on the previously created database objects and staging tables.

---

# Step 5 — Initialize User Accounts

Return to MySQL Shell:

Execute:

```sql
source dpa_seed/05_user_accounts_seed.sql;
source dpa_seed/06_withholding_tax_seed.sql;
```

---

# Step 6 — Continue Report Deployment

After successful initialization:

Create the payslip view:

```sql
source dpa_reports/01_employee_payslip_view.sql;
```

Validate:

```sql
SHOW FULL TABLES WHERE Table_type='VIEW';
```

Expected:

```text
vw_employee_payslip
```

---

# Deployment Checklist

Before considering the setup complete:

- [ ] Correct Git branch selected
- [ ] Latest changes pulled
- [ ] `.env` created
- [ ] Database connection tested
- [ ] Schema scripts executed
- [ ] Seed scripts executed
- [ ] ETL staging tables created
- [ ] Python virtual environment activated
- [ ] Python ETL scripts executed in order
- [ ] User accounts initialized
- [ ] Payslip view created
- [ ] Validation scripts passed
