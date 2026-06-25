-- ----------------------------------------------------------------------------
--  1. Total compensation and top-earner ranking
-- ----------------------------------------------------------------------------
SELECT
    e.employee_id,
    e.full_name,
    d.department_name,
    c.base_salary,
    c.allowance,
    c.bonus,
    c.overtime_pay,
    c.total_income,
    RANK() OVER (ORDER BY c.total_income DESC) AS overall_rank,
    RANK() OVER (PARTITION BY e.department_id
                 ORDER BY c.total_income DESC) AS dept_rank
FROM employees e
JOIN compensation c ON c.employee_id = e.employee_id
JOIN departments  d ON d.department_id = e.department_id
WHERE e.employment_status = 'Active'
ORDER BY c.total_income DESC
LIMIT 10;


-- ----------------------------------------------------------------------------
--  2. Performance and KPI analysis by department
-- ----------------------------------------------------------------------------
WITH latest AS (
    SELECT * FROM performance_reviews
    WHERE review_year = 2024
)
SELECT
    d.department_name,
    ROUND(AVG(l.kpi_score), 1) AS avg_kpi,
    ROUND(AVG(l.final_performance_score), 1) AS avg_final,
    MAX(l.final_performance_score) AS top_score,
    MIN(l.final_performance_score) AS low_score,
    COUNT(*) AS reviewed_employees
FROM latest l
JOIN employees   e ON e.employee_id = l.employee_id
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY avg_final DESC;


-- ----------------------------------------------------------------------------
--  3. Geographic and domicile analysis
-- ----------------------------------------------------------------------------
SELECT
    e.domicile_province,
    e.domicile_city,
    COUNT(*) AS headcount,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total,
    SUM(CASE WHEN e.work_location = 'Remote' THEN 1 ELSE 0 END) AS remote_workers
FROM employees e
WHERE e.employment_status = 'Active'
GROUP BY e.domicile_province, e.domicile_city
ORDER BY headcount DESC;


-- ----------------------------------------------------------------------------
--  5. Promotion recommendation
--  (numbering follows the article)
-- ----------------------------------------------------------------------------
WITH perf AS (
    SELECT employee_id, kpi_score, leadership_score,
           attendance_score, final_performance_score
    FROM performance_reviews
    WHERE review_year = 2024
),
tenure AS (
    SELECT employee_id,
           EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_service
    FROM employees
)
SELECT
    e.employee_id,
    e.full_name,
    d.department_name,
    j.job_level,
    p.kpi_score,
    p.leadership_score,
    t.years_service,
    CASE
        WHEN p.kpi_score >= 85 AND p.leadership_score >= 80
             AND t.years_service >= 2 AND p.attendance_score >= 90
        THEN 'Strongly Recommended'
        WHEN p.kpi_score >= 80 AND t.years_service >= 2
        THEN 'Consider'
        ELSE 'Not Yet'
    END AS promotion_status,
    DENSE_RANK() OVER (
        PARTITION BY e.department_id
        ORDER BY p.final_performance_score DESC) AS dept_perf_rank
FROM employees e
JOIN perf p ON p.employee_id = e.employee_id
JOIN tenure t ON t.employee_id = e.employee_id
JOIN departments d ON d.department_id = e.department_id
JOIN jobs j ON j.job_id = e.job_id
WHERE e.employment_status = 'Active'
ORDER BY promotion_status, dept_perf_rank;


-- ----------------------------------------------------------------------------
--  6. Work experience versus pay and performance
-- ----------------------------------------------------------------------------
SELECT
    CASE
        WHEN ex.years_of_experience < 3  THEN '0-3 yrs'
        WHEN ex.years_of_experience < 6  THEN '3-6 yrs'
        WHEN ex.years_of_experience < 10 THEN '6-10 yrs'
        ELSE '10+ yrs'
    END AS experience_band,
    COUNT(*) AS employees,
    ROUND(AVG(c.total_income)) AS avg_total_income,
    ROUND(AVG(pr.final_performance_score), 1) AS avg_performance
FROM employee_experience ex
JOIN employees e ON e.employee_id = ex.employee_id
JOIN compensation c ON c.employee_id = ex.employee_id
JOIN performance_reviews pr ON pr.employee_id = ex.employee_id
                            AND pr.review_year = 2024
GROUP BY experience_band
ORDER BY MIN(ex.years_of_experience);


-- ----------------------------------------------------------------------------
--  7. Employees paid outside their job's official band
-- ----------------------------------------------------------------------------
SELECT e.full_name, j.job_title, j.job_level,
       c.base_salary, j.min_salary, j.max_salary,
       CASE
           WHEN c.base_salary < j.min_salary THEN 'Below Band'
           WHEN c.base_salary > j.max_salary THEN 'Above Band'
           ELSE 'Within Band'
       END AS band_status
FROM employees e
JOIN compensation c ON c.employee_id = e.employee_id
JOIN jobs j         ON j.job_id = e.job_id
WHERE c.base_salary < j.min_salary OR c.base_salary > j.max_salary
ORDER BY band_status, c.base_salary;


-- ----------------------------------------------------------------------------
--  8. Salary fairness: gender pay gap by job level
-- ----------------------------------------------------------------------------
WITH pay AS (
    SELECT j.job_level,
           e.gender,
           ROUND(AVG(c.base_salary)) AS avg_base,
           COUNT(*) AS n
    FROM employees e
    JOIN compensation c ON c.employee_id = e.employee_id
    JOIN jobs j         ON j.job_id = e.job_id
    WHERE e.employment_status = 'Active'
    GROUP BY j.job_level, e.gender
)
SELECT
    job_level,
    gender,
    avg_base,
    n,
    CASE
        WHEN gender = 'Male' THEN '—'
        ELSE ROUND(
                 100.0 * (avg_base - MAX(avg_base) FILTER (WHERE gender = 'Male')
                                     OVER (PARTITION BY job_level))
                 / NULLIF(MAX(avg_base) FILTER (WHERE gender = 'Male')
                                     OVER (PARTITION BY job_level), 0)
             , 1) || '%'
    END AS "gap vs. other"
FROM pay
ORDER BY
    CASE job_level
        WHEN 'Intern' THEN 1 WHEN 'Junior' THEN 2 WHEN 'Mid' THEN 3
        WHEN 'Senior' THEN 4 WHEN 'Manager' THEN 5 WHEN 'Director' THEN 6
        ELSE 9 END,
    gender DESC;


-- ----------------------------------------------------------------------------
--  9. Retention and turnover by department
-- ----------------------------------------------------------------------------
WITH dept_counts AS (
    SELECT department_id, COUNT(*) AS total_emp
    FROM employees
    GROUP BY department_id
),
dept_exits AS (
    SELECT e.department_id, COUNT(*) AS exits
    FROM employees e
    JOIN turnover t ON t.employee_id = e.employee_id
    GROUP BY e.department_id
)
SELECT
    d.department_name,
    dc.total_emp,
    COALESCE(de.exits, 0)                                   AS exits,
    ROUND(100.0 * COALESCE(de.exits,0) / dc.total_emp, 1)   AS turnover_rate_pct,
    RANK() OVER (ORDER BY
        100.0 * COALESCE(de.exits,0) / dc.total_emp DESC)   AS attrition_rank
FROM dept_counts dc
JOIN departments d  ON d.department_id = dc.department_id
LEFT JOIN dept_exits de ON de.department_id = dc.department_id
ORDER BY turnover_rate_pct DESC;


-- ----------------------------------------------------------------------------
--  10. Most common resignation reasons
-- ----------------------------------------------------------------------------
SELECT resignation_reason,
       COUNT(*)                                       AS leavers,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM turnover
GROUP BY resignation_reason
ORDER BY leavers DESC;


-- ----------------------------------------------------------------------------
--  11. Active employees flagged by flight risk
-- ----------------------------------------------------------------------------
SELECT e.full_name, d.department_name,
       pr.final_performance_score, a.attendance_rate,
       CASE
           WHEN pr.final_performance_score < 75
                AND a.attendance_rate < 85 THEN 'High Risk'
           WHEN pr.final_performance_score < 80
                 OR a.attendance_rate < 90 THEN 'Medium Risk'
           ELSE 'Low Risk'
       END AS flight_risk
FROM employees e
JOIN performance_reviews pr ON pr.employee_id = e.employee_id
                            AND pr.review_year = 2024
JOIN attendance a ON a.employee_id = e.employee_id
                  AND a.attendance_month = '2024-11-01'
JOIN departments d ON d.department_id = e.department_id
WHERE e.employment_status = 'Active'
ORDER BY flight_risk;


-- ----------------------------------------------------------------------------
--  12. Workforce planning and headcount gaps
-- ----------------------------------------------------------------------------
SELECT
    d.department_name,
    COUNT(*) FILTER (WHERE e.employment_status = 'Active') AS active_headcount,
    COUNT(*) FILTER (WHERE j.job_level IN ('Junior','Mid')) AS ic_pipeline,
    COUNT(*) FILTER (WHERE j.job_level IN ('Manager','Director')) AS leadership,
    SUM(CASE WHEN t.replacement_needed = 'Yes' THEN 1 ELSE 0 END) AS replacements_needed
FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN jobs j ON j.job_id = e.job_id
LEFT JOIN turnover t ON t.employee_id = e.employee_id
GROUP BY d.department_name
ORDER BY replacements_needed DESC, active_headcount DESC;


-- ----------------------------------------------------------------------------
--  13. Year-over-year KPI trend (window LAG)
-- ----------------------------------------------------------------------------
WITH dept_year AS (
    SELECT e.department_id,
           pr.review_year,
           AVG(pr.kpi_score) AS avg_kpi
    FROM performance_reviews pr
    JOIN employees e ON e.employee_id = pr.employee_id
    GROUP BY e.department_id, pr.review_year
)
SELECT d.department_name,
       dy.review_year,
       ROUND(dy.avg_kpi, 1) AS avg_kpi,
       ROUND(dy.avg_kpi - LAG(dy.avg_kpi) OVER (
             PARTITION BY dy.department_id
             ORDER BY dy.review_year), 1) AS yoy_change
FROM dept_year dy
JOIN departments d ON d.department_id = dy.department_id
ORDER BY d.department_name, dy.review_year;


-- ----------------------------------------------------------------------------
--  BONUS: HR Executive Summary (single-row dashboard)
--  Included for completeness; not shown as a separate section in the article.
-- ----------------------------------------------------------------------------
WITH base AS (
    SELECT
        COUNT(*) FILTER (WHERE employment_status = 'Active')   AS active_headcount,
        COUNT(*) FILTER (WHERE employment_status <> 'Active')  AS exited
    FROM employees
),
perf AS (
    SELECT ROUND(AVG(final_performance_score), 1) AS avg_perf
    FROM performance_reviews WHERE review_year = 2024
),
pay AS (
    SELECT SUM(total_income) AS monthly_payroll,
           ROUND(AVG(total_income)) AS avg_income
    FROM compensation c
    JOIN employees e ON e.employee_id = c.employee_id
    WHERE e.employment_status = 'Active'
),
promo AS (
    SELECT COUNT(*) AS promo_ready
    FROM performance_reviews
    WHERE review_year = 2024
      AND kpi_score >= 85 AND leadership_score >= 80
)
SELECT b.active_headcount,
       b.exited,
       ROUND(100.0 * b.exited / (b.active_headcount + b.exited), 1) AS turnover_pct,
       p.avg_perf,
       pay.monthly_payroll,
       pay.avg_income,
       pr.promo_ready
FROM base b CROSS JOIN perf p CROSS JOIN pay CROSS JOIN promo pr;
