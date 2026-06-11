import pandas as pd
import mysql.connector
from decouple import config
import numpy as np
from pathlib import Path

# =========================
# DB CONFIG
# =========================
conn = mysql.connector.connect(
    host=config("DB_HOST"),
    user=config("DB_USER"),
    password=config("DB_PASSWORD"),
    database=config("DB_NAME"),
    port=config("DB_PORT", cast=int)
)

cursor = conn.cursor()

# =========================
# LOAD CSV
# =========================
BASE_DIR = Path(__file__).resolve().parent.parent
csv_path = BASE_DIR / "datasets" / "employees.csv"

df = pd.read_csv(csv_path)

# =========================
# CLEAN COLUMN NAMES
# =========================
df.columns = df.columns.str.strip()

# =========================
# RENAME COLUMNS
# =========================
df = df.rename(columns={
    "Employee #": "employee_no",
    "Last Name": "last_name",
    "First Name": "first_name",
    "Birthday": "birthday",
    "Address": "address",
    "Phone Number": "phone",
    "SSS #": "sss",
    "Philhealth #": "philhealth",
    "TIN #": "tin",
    "Pag-ibig #": "pagibig",
    "Status": "employment_status",
    "Position": "job_position",
    "Immediate Supervisor": "supervisor_name",
    "Basic Salary": "basic_salary",
    "Rice Subsidy": "rice_subsidy",
    "Phone Allowance": "phone_allowance",
    "Clothing Allowance": "clothing_allowance",
    "Gross Semi-monthly Rate": "gross_semi_monthly",
    "Hourly Rate": "hourly_rate"
})

# =========================
# DATA CLEANING
# =========================

# Convert birthday
df["birthday"] = pd.to_datetime(
    df["birthday"],
    format="%m/%d/%Y",
    errors="coerce"
).dt.date

# Replace NULL strings
df = df.replace("NULL", None)

# Replace NaN with None
df = df.replace({np.nan: None})

# Numeric columns
num_cols = [
    "basic_salary",
    "rice_subsidy",
    "phone_allowance",
    "clothing_allowance",
    "gross_semi_monthly",
    "hourly_rate"
]

for col in num_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# Final NaN cleanup
df = df.where(pd.notnull(df), None)

# =========================
# FINAL COLUMN ORDER
# =========================
df = df[
    [
        "employee_no",
        "last_name",
        "first_name",
        "birthday",
        "address",
        "phone",
        "sss",
        "philhealth",
        "tin",
        "pagibig",
        "employment_status",
        "job_position",
        "supervisor_name",
        "basic_salary",
        "rice_subsidy",
        "phone_allowance",
        "clothing_allowance",
        "gross_semi_monthly",
        "hourly_rate"
    ]
]

# =========================
# INSERT QUERY
# =========================
insert_query = """
INSERT INTO employee_staging (
    employee_no,
    last_name,
    first_name,
    birthday,
    address,
    phone,
    sss,
    philhealth,
    tin,
    pagibig,
    employment_status,
    job_position,
    supervisor_name,
    basic_salary,
    rice_subsidy,
    phone_allowance,
    clothing_allowance,
    gross_semi_monthly,
    hourly_rate
)
VALUES (
    %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s,
    %s, %s, %s, %s
)
"""

# =========================
# INSERT DATA
# =========================
data = df.values.tolist()

cursor.executemany(insert_query, data)

conn.commit()

print(f"Loaded {cursor.rowcount} rows into employee_staging")

cursor.close()
conn.close()