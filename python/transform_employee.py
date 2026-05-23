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

    # 1. EMPLOYEES
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
        WHERE employee_no IS NOT NULL;
    """)
    conn.commit()

    # 2. JOB POSITIONS
    cursor.execute("""
        INSERT IGNORE INTO job_position (position_name)
        SELECT DISTINCT job_position
        FROM employee_staging
        WHERE job_position IS NOT NULL;
    """)
    conn.commit()

    # 3. DEPARTMENT
    cursor.execute("""
        INSERT INTO department (department_name, description)
        SELECT 'General', 'Default department'
        WHERE NOT EXISTS (
            SELECT 1 FROM department WHERE department_name = 'General'
        );
    """)
    conn.commit()

    # 4. EMPLOYMENT HISTORY
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

    # 5. POSITION ASSIGNMENT
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
        JOIN department d ON d.department_name = 'General';
    """)
    conn.commit()

    # 6. SUPERVISORS
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