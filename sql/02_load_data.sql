-- ============================================================================
--  HR ANALYTICS  |  02 - LOAD DATA FROM CSV
--
--  Loads the full synthetic dataset (1,000 employees) from the /data folder.
--  Run this AFTER 01_schema.sql, from the repository root so the relative
--  paths resolve:
--
--      psql -d hr_analytics -f sql/01_schema.sql
--      psql -d hr_analytics -f sql/02_load_data.sql
--
--  Import order matters because of foreign keys:
--      departments -> jobs -> employees -> all fact tables.
--
--  The CSV files are UTF-8 (no BOM). HEADER true skips the column-name row;
--  NULL '' reads empty strings (e.g. manager_id for top managers) as NULL.
-- ============================================================================

\copy departments         FROM 'data/01_departments.csv'         WITH (FORMAT csv, HEADER true, NULL '');
\copy jobs                FROM 'data/02_jobs.csv'                WITH (FORMAT csv, HEADER true, NULL '');
\copy employees           FROM 'data/03_employees.csv'           WITH (FORMAT csv, HEADER true, NULL '');
\copy compensation        FROM 'data/04_compensation.csv'        WITH (FORMAT csv, HEADER true, NULL '');
\copy performance_reviews FROM 'data/05_performance_reviews.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy promotion_history   FROM 'data/06_promotion_history.csv'   WITH (FORMAT csv, HEADER true, NULL '');
\copy training            FROM 'data/07_training.csv'            WITH (FORMAT csv, HEADER true, NULL '');
\copy attendance          FROM 'data/08_attendance.csv'          WITH (FORMAT csv, HEADER true, NULL '');
\copy employee_experience FROM 'data/09_employee_experience.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy turnover            FROM 'data/10_turnover.csv'            WITH (FORMAT csv, HEADER true, NULL '');

-- Verification ---------------------------------------------------------------
SELECT 'departments'         AS table_name, COUNT(*) AS rows FROM departments
UNION ALL SELECT 'jobs',                COUNT(*) FROM jobs
UNION ALL SELECT 'employees',           COUNT(*) FROM employees
UNION ALL SELECT 'compensation',        COUNT(*) FROM compensation
UNION ALL SELECT 'performance_reviews', COUNT(*) FROM performance_reviews
UNION ALL SELECT 'promotion_history',   COUNT(*) FROM promotion_history
UNION ALL SELECT 'training',            COUNT(*) FROM training
UNION ALL SELECT 'attendance',          COUNT(*) FROM attendance
UNION ALL SELECT 'employee_experience', COUNT(*) FROM employee_experience
UNION ALL SELECT 'turnover',            COUNT(*) FROM turnover
ORDER BY table_name;
