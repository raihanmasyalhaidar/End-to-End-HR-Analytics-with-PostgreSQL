-- ============================================================================
--  HR ANALYTICS  |  SAMPLE SYNTHETIC DATA  (illustrative excerpt)
--
--  These INSERT statements are representative samples from each table, matching
--  the examples shown in the article. They illustrate the database structure,
--  value ranges, and relationships between tables. The FULL dataset (1,000
--  employees) is provided as CSV files in /data and loaded via
--  sql/02_load_data.sql — you do NOT need to run this file to use the project.
-- ============================================================================

-- 1. departments
INSERT INTO departments (department_id, department_name, division, director_name) VALUES
(1, 'Engineering',      'Technology', 'Rangga Pratama'),
(2, 'Data & Analytics', 'Technology', 'Rangga Pratama'),
(4, 'Sales',            'Commercial', 'Sari Wijaya');

-- 2. jobs
INSERT INTO jobs (job_id, job_title, job_level, career_path, min_salary, max_salary) VALUES
(2, 'Software Engineer',        'Mid',     'Individual Contributor', 11000000, 17000000),
(3, 'Senior Software Engineer', 'Senior',  'Individual Contributor', 17000000, 26000000),
(6, 'Data Scientist',           'Mid',     'Individual Contributor', 13000000, 20000000);

-- 3. employees
-- (Managers 1010 and 1011 are inserted first so manager_id references resolve.)
INSERT INTO employees (employee_id, full_name, gender, age, hire_date,
    employment_status, department_id, job_id, manager_id, work_location, employee_type) VALUES
(1010, 'Joko Susilo',    'Male',   47, '2012-01-09', 'Active',   1, 3, NULL, 'Jakarta HQ',     'Permanent'),
(1011, 'Hana Pertiwi',   'Female', 45, '2014-08-04', 'Active',   2, 6, NULL, 'Jakarta HQ',     'Permanent'),
(1001, 'Adi Nugroho',   'Male',   34, '2019-03-01', 'Active',   1, 3, 1010, 'Jakarta HQ',     'Permanent'),
(1002, 'Bunga Lestari',  'Female', 28, '2021-07-15', 'Active',   2, 6, 1011, 'Bandung Office', 'Permanent'),
(1005, 'Eko Saputra',    'Male',   38, '2017-05-20', 'Resigned', 1, 2, 1010, 'Remote',         'Permanent');

-- 4. compensation
INSERT INTO compensation (compensation_id, employee_id, base_salary, allowance,
    bonus, overtime_pay, total_income, salary_grade, effective_date) VALUES
(1, 1001, 21000000, 3000000, 4000000, 500000, 28500000, 'G5', '2025-01-01'),
(2, 1002, 15500000, 2500000, 2000000, 300000, 20300000, 'G4', '2025-01-01'),
(3, 1010, 34000000, 5000000, 8000000,      0, 47000000, 'G7', '2025-01-01');

-- 5. performance_reviews
INSERT INTO performance_reviews (review_id, employee_id, review_year, kpi_score,
    leadership_score, attendance_score, final_performance_score, performance_category) VALUES
(1, 1001, 2024, 91.0, 84.0, 95.0, 89.8, 'Exceeds'),
(2, 1002, 2024, 95.0, 80.0, 97.0, 91.6, 'Outstanding'),
(5, 1005, 2024, 68.0, 60.0, 75.0, 67.6, 'Needs Improvement');

-- 6. turnover
INSERT INTO turnover (turnover_id, employee_id, resignation_date,
    resignation_reason, exit_status, replacement_needed) VALUES
(1, 1005, '2025-02-28', 'Better Offer (Compensation)', 'Voluntary', 'Yes');
