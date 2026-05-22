import mysql.connector
from decouple import config

conn = mysql.connector.connect(
    host=config("DB_HOST"),
    user=config("DB_USER"),
    password=config("DB_PASSWORD"),
    database=config("DB_NAME"),
    port=config("DB_PORT", cast=int),
)

cursor = conn.cursor()

try:
    print("STARTING ATTENDANCE TRANSFORMATION")

    # =========================================
    # INSERT ATTENDANCE RECORDS
    # =========================================
    cursor.execute("""

    INSERT IGNORE INTO attendance_record (
        employee_pk,
        attendance_date,
        time_in,
        time_out,
        hours_worked,
        late_minutes,
        undertime_minutes
    )

    SELECT
        e.employee_pk,

        s.attendance_date,

        s.log_in,

        s.log_out,

        ROUND(
            TIMESTAMPDIFF(
                MINUTE,
                s.log_in,
                s.log_out
            ) / 60,
            2
        ) AS hours_worked,

        CASE
    WHEN s.log_in > CAST('09:00:00' AS TIME)
    THEN TIMESTAMPDIFF(
        MINUTE,
        CAST('09:00:00' AS TIME),
        s.log_in
    )
    ELSE 0
END AS late_minutes,

CASE
    WHEN s.log_out < CAST('18:00:00' AS TIME)
    THEN TIMESTAMPDIFF(
        MINUTE,
        s.log_out,
        CAST('18:00:00' AS TIME)
    )
    ELSE 0
END AS undertime_minutes

    FROM attendance_staging s

    JOIN employee e
        ON e.employee_no = s.employee_no;

    """)

    conn.commit()

    print("ATTENDANCE TRANSFORMATION COMPLETED")

except Exception as e:
    conn.rollback()

    print("ATTENDANCE TRANSFORMATION FAILED")

    print(str(e))

finally:
    cursor.close()
    conn.close()
