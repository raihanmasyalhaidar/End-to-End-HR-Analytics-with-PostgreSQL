DROP TABLE IF EXISTS turnover, employee_experience, attendance, training,
                     promotion_history, performance_reviews, compensation,
                     employees, jobs, departments CASCADE;

-- Departments ----------------------------------------------------------------
CREATE TABLE departments (
    department_id   INTEGER PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    division        VARCHAR(50),
    director_name   VARCHAR(100)
);

-- Jobs -----------------------------------------------------------------------
CREATE TABLE jobs (
    job_id      INTEGER PRIMARY KEY,
    job_title   VARCHAR(80) NOT NULL,
    job_level   VARCHAR(20),
    career_path VARCHAR(40),
    min_salary  BIGINT,
    max_salary  BIGINT
);

-- Employees (core dimension) -------------------------------------------------
CREATE TABLE employees (
    employee_id       INTEGER PRIMARY KEY,
    full_name         VARCHAR(100) NOT NULL,
    gender            VARCHAR(10),
    age               INTEGER,
    date_of_birth     DATE,
    marital_status    VARCHAR(15),
    education_level   VARCHAR(20),
    domicile_city     VARCHAR(50),
    domicile_province VARCHAR(50),
    hire_date         DATE,
    employment_status VARCHAR(15),
    department_id     INTEGER REFERENCES departments(department_id),
    job_id            INTEGER REFERENCES jobs(job_id),
    manager_id        INTEGER,
    work_location     VARCHAR(50),
    employee_type     VARCHAR(15)
);

-- Compensation ---------------------------------------------------------------
CREATE TABLE compensation (
    compensation_id INTEGER PRIMARY KEY,
    employee_id     INTEGER REFERENCES employees(employee_id),
    base_salary     BIGINT,
    allowance       BIGINT,
    bonus           BIGINT,
    overtime_pay    BIGINT,
    total_income    BIGINT,
    salary_grade    VARCHAR(5),
    effective_date  DATE
);

-- Performance Reviews --------------------------------------------------------
CREATE TABLE performance_reviews (
    review_id               INTEGER PRIMARY KEY,
    employee_id             INTEGER REFERENCES employees(employee_id),
    review_year             INTEGER,
    kpi_score               NUMERIC(6,2),
    productivity_score      NUMERIC(6,2),
    attendance_score        NUMERIC(6,2),
    leadership_score        NUMERIC(6,2),
    teamwork_score          NUMERIC(6,2),
    final_performance_score NUMERIC(6,2),
    performance_category    VARCHAR(20)
);

-- Promotion History ----------------------------------------------------------
CREATE TABLE promotion_history (
    promotion_id       INTEGER PRIMARY KEY,
    employee_id        INTEGER REFERENCES employees(employee_id),
    previous_job_level VARCHAR(20),
    new_job_level      VARCHAR(20),
    promotion_date     DATE,
    promotion_reason   VARCHAR(120)
);

-- Training -------------------------------------------------------------------
CREATE TABLE training (
    training_id          INTEGER PRIMARY KEY,
    employee_id          INTEGER REFERENCES employees(employee_id),
    training_name        VARCHAR(80),
    training_category    VARCHAR(40),
    training_date        DATE,
    training_score       NUMERIC(6,2),
    certification_status VARCHAR(20)
);

-- Attendance -----------------------------------------------------------------
CREATE TABLE attendance (
    attendance_id    INTEGER PRIMARY KEY,
    employee_id      INTEGER REFERENCES employees(employee_id),
    attendance_month DATE,
    working_days     INTEGER,
    present_days     INTEGER,
    absent_days      INTEGER,
    late_days        INTEGER,
    leave_days       INTEGER,
    attendance_rate  NUMERIC(6,2)
);

-- Employee Experience --------------------------------------------------------
CREATE TABLE employee_experience (
    experience_id       INTEGER PRIMARY KEY,
    employee_id         INTEGER REFERENCES employees(employee_id),
    previous_company    VARCHAR(80),
    previous_role       VARCHAR(80),
    years_of_experience NUMERIC(5,1),
    industry_background VARCHAR(50)
);

-- Turnover -------------------------------------------------------------------
CREATE TABLE turnover (
    turnover_id        INTEGER PRIMARY KEY,
    employee_id        INTEGER REFERENCES employees(employee_id),
    resignation_date   DATE,
    resignation_reason VARCHAR(60),
    exit_status        VARCHAR(20),
    replacement_needed VARCHAR(5)
);

-- Optional indexes for analytical workloads ----------------------------------
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE INDEX idx_emp_job  ON employees(job_id);
CREATE INDEX idx_perf_emp ON performance_reviews(employee_id, review_year);
CREATE INDEX idx_comp_emp ON compensation(employee_id);
