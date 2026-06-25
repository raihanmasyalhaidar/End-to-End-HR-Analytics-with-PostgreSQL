# 👥 People Behind the Numbers: An End-to-End HR Analytics Project with PostgreSQL

> Turning fragmented HR data from a 1,000-employee enterprise into evidence-based insight for compensation, performance, promotion, retention, and workforce-planning decisions.

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![SQL](https://img.shields.io/badge/SQL-CTEs%20%26%20Window%20Functions-blue)](https://www.postgresql.org/docs/current/queries.html)
[![Domain](https://img.shields.io/badge/Domain-People%20Analytics-1F3864)]()
[![Data](https://img.shields.io/badge/Data-Synthetic%20%C2%B7%201%2C000%20employees-2E5496)]()
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

[📖 Read the full article on Medium](https://medium.com/@raihanmasyalhaidar/end-to-end-hr-analytics-with-postgresql-490464936ae9)

---

## 📌 Overview

As organizations scale past a thousand employees, the People function becomes a **data-rich but insight-poor** environment. Compensation, performance, attendance, training, promotion, and attrition are all recorded somewhere, yet rarely connected. This fragmentation makes it hard to answer fundamental questions: who is genuinely ready for promotion, whether pay is fair, and which teams are most at risk of losing talent.

This project simulates a comprehensive analytics engagement for **Nusantara Digital Group**, a fictional national technology and services company designed to reflect the complexity and scale of a modern Indonesian enterprise workforce. It demonstrates the complete lifecycle of a SQL-driven initiative — from designing a normalized relational schema and generating realistic synthetic data, to developing layered analytical queries and translating outputs into **actionable business insights and strategic recommendations**.

The headline picture is a **healthy but uneven** workforce: an average performance score of **82.2** across **886 active employees**, an overall turnover rate of **11.4%**, but with performance and retention pressure concentrated in the **commercial functions** (Sales, Product, Customer Success). Pay is driven **more by tenure than by performance**, a small but consistent **gender pay gap** appears across several levels, and a strong **promotion pipeline** sits ready to be activated.

> All data is entirely synthetic and was generated programmatically. No real employee, salary, or personnel records were used.

---

## 🔑 Key Findings

| Theme | Finding |
| --- | --- |
| **Compensation** | Pay rises sharply with experience (**Rp 16.8M → Rp 31.4M**) while performance stays flat (**81–83**) — the company rewards **tenure more than performance** |
| **Performance** | **Data & Analytics** leads (avg final **89.9**); **Sales** trails (**76.6**) with the widest internal spread (**58.8 → 90.3**) |
| **Retention** | Highest turnover in **Product (17.8%)** and **Customer Success (15.7%)**; Engineering & Sales have the most absolute exits at moderate rates due to size |
| **Why people leave** | **Better compensation offers (25.4%)** is the top driver, then performance terminations (21.1%) and career growth elsewhere (16.7%) — most are **addressable** |
| **Pay fairness** | A small but **consistent gender pay gap** (~**0.9%–4.1%**) at Junior, Mid, and Senior levels; reverses slightly at Manager (**+1.5%**) |
| **Out-of-band pay** | Above- and below-band salaries appear across multiple functions — bands may have fallen behind market or reflect undocumented adjustments |
| **Talent pipeline** | **311 active employees** already meet the KPI & leadership thresholds for promotion |
| **Workforce gaps** | **Sales** needs the most backfills (**18**), then Engineering (**17**) and Customer Success (**12**) |

---

## 🗂️ Table of Contents

- [Business Problem](#-business-problem)
- [Dataset](#-dataset)
- [Methodology](#-methodology)
- [Analysis Highlights](#-analysis-highlights)
- [Strategic Recommendations](#-strategic-recommendations)
- [Project Structure](#-project-structure)
- [Tech Stack](#️-tech-stack)
- [Reproduce This Analysis](#️-reproduce-this-analysis)
- [Read More](#-read-more)
- [License](#-license)

---

## 🎯 Business Problem

Leadership can readily see headcount and payroll totals, but routine reporting leaves the most important questions unanswered:

- Which employees generate the highest total compensation, and is pay aligned with performance rather than tenure alone?
- How is performance distributed across departments, and how has it evolved year over year?
- Which employees are genuinely ready for promotion based on transparent, defensible criteria?
- Where are the highest-performing employees who could be redeployed to teams short on talent?
- To what extent does pay vary by gender and job level, and are there inequities that require review?
- Which departments are losing the most people, why are employees leaving, and who is at risk now?
- Is the workforce aligned with business needs, or are there headcount gaps and backfill shortages?
- Does the company have a healthy promotion pipeline to support growth and retention?

At its core, this is a problem of **decision visibility and analytical integration**. The organization needs a unified, queryable foundation that connects employees, compensation, performance, promotions, training, attendance, experience, and turnover into a single source of truth — enabling a move from intuition-based management toward consistent, data-driven decisions.

---

## 💾 Dataset

All data is **synthetic**, generated to replicate the structure, distribution patterns, and statistical characteristics of a real Indonesian enterprise workforce. It consists of **10 interconnected tables** centered on `employees`.

| Table | Rows | Description |
| --- | ---: | --- |
| `employees` | 1,000 | Core master data: demographics, education, domicile, hire date, status, department, job, manager |
| `departments` | 10 | Departments, parent divisions, and directors |
| `jobs` | 18 | Job titles, levels, career paths, and salary bands |
| `compensation` | 1,000 | Base salary, allowances, bonus, overtime, total income, salary grade |
| `performance_reviews` | 2,104 | Annual KPI, productivity, attendance, leadership, teamwork scores + final score |
| `promotion_history` | 382 | Promotion events: previous/new level and reason |
| `training` | 2,400 | Training enrollments, categories, dates, scores, certification status |
| `attendance` | 4,743 | Monthly working days, presence, absences, lateness, attendance rate |
| `employee_experience` | 1,000 | Previous company, role, years of experience, industry |
| `turnover` | 114 | Resignation date, reason, exit status, replacement needed |

> **Design principles:** salaries respect each job's min–max band (with a deliberate minority of out-of-band cases for fairness analysis); performance scores center on "Meets" with realistic tails; ~11–13% of employees have left with matching turnover records; reviews span 2022–2024 to enable trend analysis. All figures are in Indonesian Rupiah (IDR), monthly.

---

## 🔬 Methodology

The project follows a structured, reproducible framework. Each stage builds on the previous one, and every result regenerates by running the SQL scripts in order.

1. **Schema Design** — a normalized 10-table relational model with primary/foreign keys and a self-referencing manager hierarchy.
2. **Data Generation** — realistic synthetic data scaled to 1,000 employees, provided as CSVs and loadable in dependency order.
3. **Data Loading & Validation** — `\copy` imports with a row-count verification step confirming referential integrity.
4. **Analytical Querying** — 13 layered analyses spanning compensation, performance, promotion, fairness, retention, and planning.
5. **Business Synthesis** — translation of query outputs into prioritized, quantified recommendations for stakeholders.

---

## 📈 Analysis Highlights

### Total compensation and top-earner ranking

```sql
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
    RANK() OVER (
        PARTITION BY e.department_id
        ORDER BY c.total_income DESC
    ) AS dept_rank
FROM employees e
JOIN compensation c ON c.employee_id = e.employee_id
JOIN departments d ON d.department_id = e.department_id
WHERE e.employment_status = 'Active'
ORDER BY c.total_income DESC
LIMIT 10;
```

<img width="800" height="219" alt="image" src="https://github.com/user-attachments/assets/3a2204a9-9cc3-4c0f-ad66-493187d20cc8" />

The analysis shows that Jefri Sari received the highest total monthly compensation among active employees, earning Rp 55.40 million per month. The remaining nine highest-paid employees earned between Rp 52.58 million and Rp 54.92 million, resulting in a relatively small compensation gap of approximately Rp 2.82 million across the top-ten earners. Notably, all employees in the top-ten compensation ranking belong to the Engineering department, indicating that this department represents the highest-paid workforce segment within the organization during the observed period, while the narrow income range suggests relatively consistent compensation among employees at the highest earning level.

### Performance and KPI analysis by department

```sql
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
```

<img width="656" height="295" alt="image" src="https://github.com/user-attachments/assets/ed185265-8623-48a0-be20-8a0ed92e21c8" />

The 2024 performance review results show that the Data & Analytics department achieved the highest average performance, recording an average KPI score of 90.9 and an average final performance score of 89.9, followed by Legal & Compliance (85.3) and Product (84.9). In contrast, Sales reported the lowest average final performance score (76.6) and also recorded the lowest individual performance score (58.8) across all departments. At the individual level, the highest performance score (99.6) was achieved by an employee in Data & Analytics, while several departments, including Engineering, also demonstrated strong top performers with scores approaching 99.

Among all departments, Engineering had the largest number of reviewed employees (206), with an average final performance score of 82.8 and individual scores ranging from 62.3 to 99.0. This wide score distribution indicates greater variation in employee performance compared with smaller departments, whereas departments such as Data & Analytics and Legal & Compliance maintained both higher average performance scores and strong individual results across their reviewed employees.

### Geographic and domicile analysis

```sql
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
```

<img width="639" height="345" alt="image" src="https://github.com/user-attachments/assets/9b672a25-2847-40fc-90ce-d12ab361b939" />


The geographic distribution of active employees is concentrated in Jakarta, with 364 employees, representing 41.1% of the total active workforce. This is followed by Bandung (113 employees; 12.8%) and Surabaya (88 employees; 9.9%), while the remaining employees are distributed across other major cities, each contributing less than 7% of the total workforce. This indicates that the organization's employee base is primarily centered in the Greater Jakarta area, with additional concentrations in several regional urban centers.

Remote work adoption also varies across locations. Jakarta has the highest number of remote employees (65), followed by Bandung (18), Surabaya (16), and both Tangerang and Yogyakarta (14 each). In contrast, Denpasar and Balikpapan reported no remote employees, suggesting that remote work arrangements are more prevalent in the organization's larger workforce locations.

---

## 🚀 Strategic Recommendations

1. **Launch a Targeted Retention Effort in Commercial Functions.** Prioritize retention programs in Product, Customer Success, and Sales through targeted engagement and stay interviews to address attrition drivers.

2. **Correct Compensation for Underpaid High Performers.** Review compensation for high-performing employees whose pay may not reflect their performance to improve retention and reward fairness.

3. **Activate the Promotion Pipeline.** Strengthen transparent, performance-based promotion processes to support career growth and employee motivation.

4. **Conduct a Formal Pay-Equity Review.** Evaluate compensation equity across comparable roles while considering job level, experience, and performance.

5. **Align Workforce Planning with Backfill Needs.** Prioritize hiring and internal talent movement to address staffing needs in high-demand departments.

6. **Review Salary Bands Against the Market.** Regularly benchmark salary structures to maintain market competitiveness and compensation consistency.

7. **Leverage Internal Mobility Before External Hiring.** Utilize high-performing internal talent to fill critical vacancies before recruiting externally.

8. **Operationalize Performance Monitoring.** Deploy automated HR dashboards and regular reporting to enable continuous, data-driven workforce monitoring.
### Key Takeaway

The biggest opportunities lie in **retaining the right people and paying for performance** — strengthening the talent lifecycle (hire → develop → promote → retain) delivers more impact than across-the-board pay changes. Most of the attrition the company suffers is **addressable**, not inevitable.

---

## 📁 Project Structure

```
hr-analytics-postgresql/
├── README.md                       # You are here
├── sql/
│   ├── 01_schema.sql               # CREATE TABLE statements (DDL) with PK/FK
│   ├── 02_load_data.sql            # \copy all 10 CSVs in order + verification
│   └── 03_analysis_queries.sql     # The 13 analytical queries from the article
├── data/                           # Full synthetic dataset (1,000 employees)
│   ├── 01_departments.csv
│   ├── 02_jobs.csv
│   ├── 03_employees.csv
│   ├── 04_compensation.csv
│   ├── 05_performance_reviews.csv
│   ├── 06_promotion_history.csv
│   ├── 07_training.csv
│   ├── 08_attendance.csv
│   ├── 09_employee_experience.csv
│   └── 10_turnover.csv
├── docs/
│   └── sample_data.sql             # Representative INSERT samples
├── LICENSE
└── .gitignore
```

---

## 🛠️ Tech Stack

| Purpose | Tools |
| --- | --- |
| Database | `PostgreSQL 16` |
| Querying | ANSI SQL — CTEs, `RANK` / `DENSE_RANK` / `LAG` / `NTILE`, `FILTER`, `CASE` |
| Data | 100% synthetic — 1,000 employees across 10 related tables |
| Interfaces | `psql`, or any client (DBeaver, pgAdmin) |

---

## ⚙️ Reproduce This Analysis

```bash
# 1. Clone the repo
git clone https://github.com/<your-username>/hr-analytics-postgresql.git
cd hr-analytics-postgresql

# 2. Create the database
createdb hr_analytics

# 3. Build the schema
psql -d hr_analytics -f sql/01_schema.sql

# 4. Load the full dataset (run from the repo root so relative paths resolve)
psql -d hr_analytics -f sql/02_load_data.sql

# 5. Run the analyses
psql -d hr_analytics -f sql/03_analysis_queries.sql
```

> **Import order matters** because of foreign keys: `departments` → `jobs` → `employees` → all fact tables. The load script already follows this order. The CSVs are UTF-8 (no BOM); money columns are `BIGINT` and scores are `NUMERIC(6,2)`, so nothing overflows on import. After step 4 you should see a verification table confirming row counts (`employees = 1000`, `attendance = 4743`, …).

---

## 📚 Read More

- 📖 **Full article on Medium:** [End-to-End HR Analytics with PostgreSQL](https://medium.com/@raihanmasyalhaidar/end-to-end-hr-analytics-with-postgresql-490464936ae9)
- 💾 **Sample data:** `docs/sample_data.sql`
- 🧮 **All queries:** `sql/03_analysis_queries.sql`

---

## 📝 License

Released under the [MIT License](LICENSE). The synthetic dataset is free to reuse for learning and portfolio purposes.

---

*Written by **Raihan Masyal Haidar** · If this analysis was useful, consider giving the repo a ⭐*
