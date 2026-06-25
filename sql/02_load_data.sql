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
