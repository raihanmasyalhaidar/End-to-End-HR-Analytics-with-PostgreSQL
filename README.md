# End-to-End HR Analytics with PostgreSQL

An end-to-end SQL portfolio project that simulates a comprehensive analytics engagement for a
fictional national technology and services company, **Nusantara Digital Group**, designed to
reflect the complexity and scale of a modern Indonesian enterprise workforce. It demonstrates the
complete lifecycle of a SQL-driven analytics initiative — from designing a normalized relational
database schema and generating realistic synthetic datasets to developing layered analytical
queries and translating outputs into actionable business insights and strategic recommendations.

📖 **Full write-up on Medium:** [End-to-End HR Analytics with PostgreSQL](https://medium.com/@raihanmasyalhaidar/end-to-end-hr-analytics-with-postgresql-490464936ae9)

> All data is entirely synthetic and was generated exclusively for demonstration purposes. No real
> employee, salary, or personnel records were used.

---

## Table of Contents

- [Overview](#overview)
- [Business Problem](#business-problem)
- [Dataset](#dataset)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [The Analyses](#the-analyses)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Tech Stack](#tech-stack)
- [License](#license)

---

## Overview

As organizations scale past a thousand employees, the People function becomes a data-rich but
insight-poor environment. Compensation, performance, attendance, training, promotion, and attrition
are all recorded somewhere, yet rarely connected. This fragmentation makes it difficult to answer
fundamental questions such as who is genuinely ready for promotion, whether pay is fair, and which
teams are most at risk of losing talent.

This project builds a unified, queryable analytical foundation and uses it to answer those questions
across six dimensions: **compensation, employee performance, promotion readiness, internal mobility,
retention, and workforce planning.**

---

## Business Problem

Nusantara Digital Group has grown rapidly to more than 1,000 employees across ten departments and
several work locations throughout Indonesia. Despite extensive employee data, its data landscape
remains fragmented across functional areas, restricting analytical visibility and leaving HR
decisions to be driven by intuition rather than evidence.

The leadership team seeks answers to several critical questions:

- Which employees generate the highest total compensation, and is pay aligned with performance rather than tenure alone?
- How is performance distributed across departments, and how has it evolved year over year?
- Which employees are genuinely ready for promotion based on transparent, defensible criteria?
- Where are the highest-performing employees who could be redeployed to teams short on talent?
- To what extent does pay vary by gender and job level, and are there inequities that require review?
- Which departments are losing the most people, why are employees leaving, and who is at risk now?
- Is the workforce aligned with business needs, or are there headcount gaps and backfill shortages?
- Does the company have a healthy promotion pipeline to support growth and retention?

---

## Dataset

The data-generation process was intentionally designed to replicate the structure, distribution
patterns, and statistical characteristics of a real Indonesian enterprise workforce.

### Design Principles

- **Organizational Realism** — Headcount is concentrated in Engineering, Sales, and Data & Analytics, with smaller corporate functions such as Human Resources, Finance, and Legal & Compliance.
- **Compensation Realism** — Salaries respect each job's defined min–max band, scaled by seniority and experience, with a deliberate minority of out-of-band cases to enable pay-fairness analysis. All figures are in Indonesian Rupiah (IDR), monthly.
- **Performance Realism** — Review scores follow a believable distribution centered around "Meets," with realistic minorities of "Outstanding" and "Needs Improvement."
- **Attrition Realism** — Roughly 11–13% of employees have left, each with a matching turnover record and a plausible resignation reason.
- **Temporal Realism** — Performance reviews span three years (2022–2024) and attendance spans six months, enabling trend and year-over-year analysis.

### Data Dictionary

The project consists of **10 interconnected tables** representing the end-to-end operations of an
enterprise People function.

| Table | Rows | Description |
|---|---:|---|
| `employees` | 1,000 | Core employee master data: demographics, education, domicile, hire date, status, department, job, manager. |
| `departments` | 10 | Departments, parent divisions, and directors. |
| `jobs` | 18 | Job titles, levels, career paths, and salary bands. |
| `compensation` | 1,000 | Base salary, allowances, bonus, overtime, total income, and salary grade. |
| `performance_reviews` | 2,104 | Annual KPI, productivity, attendance, leadership, and teamwork scores, with a final score and category. |
| `promotion_history` | 382 | Promotion events: previous/new level and documented reason. |
| `training` | 2,400 | Training enrollments, categories, dates, scores, and certification status. |
| `attendance` | 4,743 | Monthly working days, presence, absences, lateness, and attendance rate. |
| `employee_experience` | 1,000 | Previous company, role, years of experience, and industry background. |
| `turnover` | 114 | Resignation date, reason, exit status, and whether a replacement is required. |

## Repository Structure

```
hr-analytics-postgresql/
├── sql/
│   ├── 01_schema.sql            # CREATE TABLE statements (DDL) with PK/FK
│   ├── 02_load_data.sql         # \copy all 10 CSVs in dependency order + verification
│   └── 03_analysis_queries.sql  # The 13 analytical queries from the article
├── data/
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
│   └── sample_data.sql          # Representative INSERT samples (from the article)
├── README.md
└── LICENSE
```

---

## Getting Started

**Prerequisites:** PostgreSQL 13 or newer.

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/hr-analytics-postgresql.git
cd hr-analytics-postgresql

# 2. Create the database
createdb hr_analytics

# 3. Build the schema
psql -d hr_analytics -f sql/01_schema.sql

# 4. Load the full synthetic dataset (run from the repo root so paths resolve)
psql -d hr_analytics -f sql/02_load_data.sql

# 5. Run the analyses
psql -d hr_analytics -f sql/03_analysis_queries.sql
```

After step 4 you should see a verification table confirming row counts
(`employees = 1000`, `attendance = 4743`, and so on).

> **Import order matters** because of foreign keys: `departments` → `jobs` → `employees` → all fact
> tables. The load script already follows this order. The CSVs are UTF-8 (no BOM); money columns are
> `BIGINT` and scores are `NUMERIC(6,2)`, so nothing overflows on import.

---

## The Analyses

The project answers the business questions through **13 analytical queries**, each combining SQL
techniques with a business interpretation. (Numbering follows the article.)

| # | Analysis | Core SQL Technique |
|---|---|---|
| 1 | Total compensation & top-earner ranking | `RANK()` over / `PARTITION BY` |
| 2 | Performance & KPI analysis by department | CTE + `GROUP BY` aggregation |
| 3 | Geographic & domicile analysis | Windowed share + conditional `SUM` |
| 5 | Promotion recommendation | CTEs + `CASE` + `DENSE_RANK` |
| 6 | Work experience vs pay & performance | `CASE` banding + `AVG` |
| 7 | Employees paid outside their band | `CASE` band classification |
| 8 | Salary fairness: gender pay gap by level | `FILTER` + windowed baseline |
| 9 | Retention & turnover by department | CTEs + `LEFT JOIN` + `RANK` |
| 10 | Most common resignation reasons | Windowed percentage |
| 11 | Active employees flagged by flight risk | Tiered `CASE` rule |
| 12 | Workforce planning & headcount gaps | `COUNT(*) FILTER (WHERE …)` |
| 13 | Year-over-year KPI trend | `LAG()` window function |

A bonus **HR executive summary** query (a single-row dashboard combining four CTEs with `CROSS JOIN`)
is included at the end of `03_analysis_queries.sql`.

---

## Key Insights

**Workforce and Performance**
- **Scale and health:** 886 active staff against 114 departures (an 11.4% turnover rate), with a healthy average performance score of 82.2.
- **Performance leadership:** Data & Analytics recorded the highest average performance at 89.9, while Sales posted the lowest at 76.6 with the widest internal spread (58.8 to 90.3).

**Retention and Attrition**
- **Highest attrition in commercial & operational functions:** Product (17.8%) and Customer Success (15.7%) recorded the highest turnover rates; Engineering and Sales had the highest absolute departures (26 and 23) at moderate rates due to their size.
- **Pay is the leading driver of exits:** Better compensation offers accounted for 25.4% of departures, followed by performance-related terminations (21.1%) and career growth elsewhere (16.7%).
- **A declining Sales trend:** Sales KPI fell year over year in 2024 (−0.9), reinforcing it as a primary area of concern.

**Compensation and Fairness**
- **Pay rewards tenure more than performance:** Average total income rises sharply across experience bands (Rp 16.8M → Rp 31.4M) while performance stays roughly flat (81–83).
- **Out-of-band salaries require review:** Above- and below-band cases appear across multiple functions and levels.
- **A small but consistent gender pay gap:** Average base pay favored men by ~0.9% to 4.1% at the Junior, Mid, and Senior levels, reversing slightly at Manager (+1.5%).

**Talent Pipeline and Planning**
- **A healthy promotion pipeline:** 311 active employees already meet the KPI and leadership thresholds for promotion consideration.
- **Concentrated backfill pressure:** Sales required the most backfills (18), followed by Engineering (17) and Customer Success (12).

---

## Business Recommendations

1. **Launch a targeted retention effort in commercial functions.** Product, Customer Success, and Sales recorded the highest attrition and weakest performance trends; prioritize stay-interviews and structured engagement to validate the pay and career drivers before allocating budget.
2. **Correct compensation for underpaid high performers.** Strong early-career performers may be underpaid; prioritize fast-track, off-cycle adjustments where the budget impact is small relative to replacement cost.
3. **Activate the promotion pipeline.** Use the promotion-recommendation engine each cycle to generate transparent, per-department shortlists, directly addressing the career-growth driver behind attrition.
4. **Conduct a formal pay-equity review.** Examine the gender pay gap with controls for role, level, experience, and performance to determine whether it persists after adjustment.
5. **Align workforce planning with backfill needs.** Pair Sales and Engineering hiring plans with internal-transfer candidates from large, talent-rich teams.
6. **Review salary bands against the market.** Above-band salaries suggest some bands have fallen behind; regular reviews maintain consistency and reduce ad-hoc exceptions.
7. **Leverage internal mobility before external hiring.** Top performers in large departments such as Data & Analytics and Engineering represent a redeployment opportunity.
8. **Operationalize performance monitoring.** Schedule headline workforce metrics as an automated monthly report and deploy a per-employee self-service dashboard.

---

## Tech Stack

- **Database:** PostgreSQL 16
- **Language:** SQL — CTEs, window functions (`RANK`, `DENSE_RANK`, `LAG`, `NTILE`), `CASE` segmentation, `FILTER` aggregates
- **Data:** 100% synthetic, generated programmatically (1,000 employees across 10 related tables)

---

## License

Released under the [MIT License](LICENSE). The synthetic dataset is free to reuse for learning and
portfolio purposes.

---

*Author: **Raihan Masyal Haidar** — Statistics graduate with 3+ years of experience in data
analytics, machine learning, and BI. If you found this useful, please consider giving the repo a ⭐.*
