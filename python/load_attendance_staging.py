import pandas as pd
import mysql.connector
from decouple import config
import numpy as np
from pathlib import Path

# =========================================
# DB CONNECTION
# =========================================
conn = mysql.connector.connect(
    host=config("DB_HOST"),
    user=config("DB_USER"),
    password=config("DB_PASSWORD"),
    database=config("DB_NAME"),
    port=config("DB_PORT", cast=int)
)

cursor = conn.cursor()

# =========================================
# LOAD CSV
# =========================================
BASE_DIR = Path(__file__).resolve().parent.parent
csv_path = BASE_DIR / "datasets" / "attendance.csv"
df = pd.read_csv(csv_path)

# =========================================
# CLEAN COLUMN NAMES
# =========================================
df.columns = df.columns.str.strip()

# =========================================
# RENAME COLUMNS
# =========================================
df = df.rename(columns={
    "EmployeeNumber": "employee_no",
    "LastName": "last_name",
    "FirstName": "first_name",
    "Date": "attendance_date",
    "LogIn": "log_in",
    "LogOut": "log_out"
})

# =========================================
# DATE CONVERSION
# =========================================
df["attendance_date"] = pd.to_datetime(
    df["attendance_date"],
    format="%m/%d/%Y",
    errors="coerce"
).dt.date

# =========================================
# TIME CONVERSION
# =========================================
df["log_in"] = pd.to_datetime(
    df["log_in"],
    format="%H:%M",
    errors="coerce"
).dt.time

df["log_out"] = pd.to_datetime(
    df["log_out"],
    format="%H:%M",
    errors="coerce"
).dt.time

# =========================================
# HANDLE NULLS
# =========================================
df = df.replace("NULL", None)
df = df.replace({np.nan: None})

# =========================================
# FINAL COLUMN ORDER
# =========================================
df = df[
    [
        "employee_no",
        "last_name",
        "first_name",
        "attendance_date",
        "log_in",
        "log_out"
    ]
]

# =========================================
# INSERT QUERY
# =========================================
insert_query = """

INSERT INTO attendance_staging (
    employee_no,
    last_name,
    first_name,
    attendance_date,
    log_in,
    log_out
)
VALUES (%s, %s, %s, %s, %s, %s)

"""

# =========================================
# EXECUTE
# =========================================
data = df.values.tolist()

cursor.executemany(insert_query, data)

conn.commit()

print(f"Loaded {cursor.rowcount} rows into attendance_staging")

cursor.close()
conn.close()