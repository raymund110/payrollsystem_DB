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
    print("STARTING EMPLOYEE TRANSFORMATION")

    # =========================================
    # 1. EMPLOYEES
    # =========================================
    cursor.execute("""
        INSERT INTO employee (
            employee_no,
            last_name,
            first_name,
            birthday,
            address,
            phone_number,
            sss_number,
            philhealth_number,
            tin_number,
            pagibig_number
        )
        SELECT
            employee_no,
            last_name,
            first_name,
            birthday,
            address,
            phone,
            sss,
            philhealth,
            tin,
            pagibig
        FROM employee_staging
        WHERE employee_no IS NOT NULL
        ON DUPLICATE KEY UPDATE
            last_name = VALUES(last_name),
            first_name = VALUES(first_name),
            birthday = VALUES(birthday),
            address = VALUES(address),
            phone_number = VALUES(phone_number),
            sss_number = VALUES(sss_number),
            philhealth_number = VALUES(philhealth_number),
            tin_number = VALUES(tin_number),
            pagibig_number = VALUES(pagibig_number);
    """)
    conn.commit()

    # =========================================
    # 2. JOB POSITIONS
    # =========================================
    cursor.execute("""
        INSERT IGNORE INTO job_position (position_name)
        SELECT DISTINCT job_position
        FROM employee_staging
        WHERE job_position IS NOT NULL;
    """)
    conn.commit()

    # =========================================
    # 3. DEPARTMENT SEED (SAFE UPSERT)
    # =========================================
    cursor.execute("""
        INSERT INTO department (department_name, description)
        VALUES
        ('IT', 'IT Department'),
        ('HR', 'HR Department'),
        ('Finance', 'Finance Department'),
        ('Accounting', 'Accounting Department'),
        ('Sales', 'Marketing Department'),
        ('Operations', 'Operations and Customer Service Department'),
        ('Leadership', 'Executive Management'),
        ('General', 'Default fallback department for unmapped roles')
        ON DUPLICATE KEY UPDATE
            description = VALUES(description);
    """)
    conn.commit()

    # =========================================
    # 4. EMPLOYMENT HISTORY
    # =========================================
    cursor.execute("""
        INSERT INTO employee_employment_history (
            employee_pk,
            status_name,
            effective_date
        )
        SELECT
            e.employee_pk,
            s.employment_status,
            CURDATE()
        FROM employee_staging s
        JOIN employee e ON e.employee_no = s.employee_no;
    """)
    conn.commit()

    # =========================================
    # 5. POSITION + DEPARTMENT ASSIGNMENT (FIXED)
    # =========================================
    cursor.execute("""
        INSERT INTO employee_position (
            employee_pk,
            position_id,
            department_id,
            effective_date,
            basic_salary
        )
        SELECT
            e.employee_pk,
            jp.position_id,
            d.department_id,
            CURDATE(),
            s.basic_salary
        FROM employee_staging s
        JOIN employee e ON e.employee_no = s.employee_no
        JOIN job_position jp ON jp.position_name = s.job_position

        LEFT JOIN department d
    ON d.department_name = CASE

        WHEN s.job_position IN (
            'Chief Executive Officer',
            'Chief Operating Officer',
            'Chief Finance Officer',
            'Chief Marketing Officer'
        ) THEN 'Leadership'

        WHEN s.job_position IN (
            'IT Operations and Systems'
        ) THEN 'IT'

        WHEN s.job_position IN (
            'HR Manager',
            'HR Team Leader',
            'HR Rank and File'
        ) THEN 'HR'

        WHEN s.job_position IN (
            'Payroll Manager',
            'Payroll Team Leader',
            'Payroll Rank and File'
        ) THEN 'Finance'

        WHEN s.job_position IN (
            'Accounting Head',
            'Account Manager',
            'Account Team Leader',
            'Account Rank and File'
        ) THEN 'Accounting'

        WHEN s.job_position IN (
            'Sales & Marketing'
        ) THEN 'Sales'

        WHEN s.job_position IN (
            'Supply Chain and Logistics',
            'Customer Service and Relations'
        ) THEN 'Operations'

        ELSE 'General'
    END
    """)
    conn.commit()

    # =========================================
    # 6. SUPERVISOR MAPPING
    # =========================================
    cursor.execute("""
        UPDATE employee e
        JOIN employee_staging s
            ON e.employee_no = s.employee_no
        JOIN employee sup
            ON CONCAT(sup.last_name, ', ', sup.first_name) = s.supervisor_name
        SET e.supervisor_employee_pk = sup.employee_pk;
    """)
    conn.commit()

    print("TRANSFORMATION SUCCESSFUL")

except Exception as e:
    conn.rollback()
    print("FAILED:", e)

finally:
    cursor.close()
    conn.close()
