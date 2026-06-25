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
- To what extent does pay vary by gender and job level, and are there inequities that require review?
- Which departments are losing the most people, why are employees leaving, and who is at risk now?
- Is the workforce aligned with business needs, or are there headcount gaps and backfill shortages?

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

SQL techniques on display: **CTEs**, **window functions** (`RANK`, `DENSE_RANK`, `LAG`, `NTILE`), **`FILTER` aggregates**, and **`CASE` segmentation**.

---

## 📈 Analysis Highlights

### Performance Is Strong Overall — but Sales Lags and Spreads Wide

<!-- Optional: replace with a chart -> ![Performance by department](charts/performance_by_department.png) -->

| Department | Avg KPI | Avg Final | Top | Low | Reviewed |
| --- | ---: | ---: | ---: | ---: | ---: |
| Data & Analytics | 90.9 | 89.9 | — | — | 87 |
| Legal & Compliance | 85.4 | 85.3 | — | — | 16 |
| Product | 86.2 | 84.9 | — | — | 67 |
| Engineering | 83.6 | 82.8 | 99.0 | 62.3 | 206 |
| Sales | 77.6 | 76.6 | 90.3 | 58.8 | 156 |

Data & Analytics leads on every measure, while **Sales records the lowest average and the single lowest individual score (58.8)**. Engineering's wide range (99.0 → 62.3) across 206 reviewed employees signals a team that needs **targeted coaching for specific cohorts** rather than uniform measures.

### Pay Rewards Tenure More Than Performance

<!-- Optional: replace with a chart -> ![Experience vs pay](charts/experience_vs_pay.png) -->

| Experience | Avg Total Income | Avg Performance |
| --- | ---: | ---: |
| 0–3 yrs | Rp 16.8M | 81.8 |
| 3–6 yrs | Rp 20.0M | 83.4 |
| 6–10 yrs | Rp 24.4M | 81.0 |
| 10+ yrs | Rp 31.4M | 82.5 |

Average income **nearly doubles** across the experience range while performance stays inside a narrow **81–83** band. The divergence is the tell: in aggregate, **pay tracks tenure, not measured output** — leaving high-performing early-career employees potentially underpaid and exposed to competitive offers.

### Attrition Is Concentrated, and Its Causes Are Addressable

<!-- Optional: replace with a chart -> ![Turnover by department](charts/turnover_by_department.png) -->

| Department | Total | Exits | Turnover % |
| --- | ---: | ---: | ---: |
| Product | 73 | 13 | 17.8% |
| Customer Success | 89 | 14 | 15.7% |
| Operations | 72 | 10 | 13.9% |
| Sales | 203 | 23 | 11.3% |
| Engineering | 232 | 26 | 11.2% |

Expressing attrition as a **rate** (not a raw count) reveals that the proportional pressure sits in **Product and Customer Success**, even though Engineering and Sales have the most absolute exits. And the leading reasons to leave — **better pay (25.4%)** and **career growth (16.7%)** — are both within the company's control.

---

## 🚀 Strategic Recommendations

- **Launch a Targeted Retention Effort in Commercial Functions.** Product, Customer Success, and Sales show the highest attrition and weakest performance trends — prioritize stay-interviews and structured engagement to validate the pay and career drivers before spending budget.

- **Correct Compensation for Underpaid High Performers.** Strong early-career performers may be underpaid; fast-track off-cycle adjustments deliver outsized retention value at small budget cost.

- **Activate the Promotion Pipeline.** Use the promotion-recommendation engine each cycle to generate transparent, per-department shortlists — directly addressing the career-growth driver behind attrition.

- **Conduct a Formal Pay-Equity Review.** Examine the gender pay gap with controls for role, level, experience, and performance to confirm whether it persists after adjustment.

- **Align Workforce Planning with Backfill Needs.** Pair Sales and Engineering hiring plans with internal-transfer candidates from large, talent-rich teams to fill roles faster and cheaper.

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
