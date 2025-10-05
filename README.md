# Data Management & Analysis

End-to-end assignments covering ETL (Python), pandas analysis, web scraping/APIs, relational design in Postgres, performance tuning, and SQLAlchemy.

---

## Tech Stack
- Python 3.x (Jupyter, pandas, numpy, matplotlib, requests, BeautifulSoup, SQLAlchemy)
- PostgreSQL 14+ (psql client)
- Markdown, ER diagrams (exported images)

---

## Repository Layout
```

.
├─ hw03/               # Sourcing data, summary stats, matplotlib
│  ├─ src/homework03.ipynb
│  ├─ data/raw/…
│  └─ README.md
├─ hw04/               # Pandas basics + freeform pandas project
│  ├─ src/traffic_accidents.ipynb
│  ├─ src/project.ipynb
│  ├─ data/raw/…
│  └─ README.md
├─ hw05/               # Web data + combining data (HTML parse, API, merges)
│  ├─ courses.ipynb
│  └─ README.md
├─ hw06/               # Single-table SQL (import, DDL, queries, report)
│  ├─ convert.ipynb
│  ├─ create_table.sql
│  ├─ import_csv.sql
│  ├─ queries.sql
│  ├─ report.md
│  └─ README.md
├─ hw07/               # ERD by inspection, joins/subqueries, normalization
│  ├─ src/part2_queries.sql
│  ├─ src/part3_01_create_staging.sql
│  ├─ src/part3_02_import.sql
│  ├─ src/part3_03_explore.sql
│  ├─ src/part4_ddl.sql
│  ├─ img/part1_nation_subset_er_diagram.png
│  ├─ img/part3_03_caers_er_diagram.png
│  └─ README.md
└─ hw08/               # Windows, views, indexing, SQLAlchemy ORM
├─ create.sql
├─ queries.sql
├─ explain_analyze.sql
├─ olympics.py
└─ README.md

````

> Large/raw datasets may be excluded due to size limits. Each sub-README includes source links and import steps.

---

## Quick Start

### Python
```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt  # or install per sub-README
jupyter lab
````

### PostgreSQL

```bash
# Start server, then for each SQL assignment:
psql -U <user> -h localhost
```

---

## Assignment Summaries

### HW03 — Sourcing Data, Summary Stats, Visualization

* **Focus:** Plain-Python ETL (csv module), numpy stats, matplotlib plots; correlation & scatter.
* **Artifacts:** `src/homework03.ipynb`, `data/raw/…`
* **Run:** Open the notebook; paths are relative to `data/raw`.

### HW04 — Pandas Basics

* **Focus:** Robust CSV import, dtype fixes, cleaning, grouping, value counts, visuals.
* **Artifacts:** `src/traffic_accidents.ipynb`, `src/project.ipynb`
* **Run:** Place raw CSVs in `data/raw/`, execute notebooks top-to-bottom.

### HW05 — Web Data & Combining Data

* **Focus:** requests + BeautifulSoup HTML parsing, `merge` joins, JSON/API to DataFrame.
* **Artifacts:** `courses.ipynb`
* **Run:** Save course HTML at repo root; run notebook.

### HW06 — Single Table SQL

* **Focus:** Table design, CSV import via `\copy`, queries, and report.
* **Artifacts:** `convert.ipynb`, `create_table.sql`, `import_csv.sql`, `queries.sql`, `report.md`
* **Run:**

```sql
createdb homework06
\c homework06
\i create_table.sql
\i import_csv.sql
\i queries.sql
```

### HW07 — ERDs, Joins/Subqueries, Normalization

* **Focus:** Multi-table exploration; staging → 3NF model; hand-written DDL.
* **Artifacts:** `src/part2_queries.sql`, staging/import/explore SQL, ERDs in `img/`, `src/part4_ddl.sql`
* **Run:** Execute SQL files in order; review ERD images.

### HW08 — Windows, Views, Indexing, SQLAlchemy

* **Focus:** `RANK()`, rolling sums, `LAG()`, EXPLAIN/ANALYZE + index, ORM insert/query.
* **Artifacts:** `create.sql`, `queries.sql`, `explain_analyze.sql`, `olympics.py`
* **Run (SQL):**

```sql
createdb homework08
\c homework08
\i create.sql
\copy noc_region FROM 'noc_regions.csv' WITH CSV HEADER NULL 'NA'
\copy athlete_event (...) FROM 'athlete_events.csv' WITH CSV HEADER NULL 'NA'
\i queries.sql
\i explain_analyze.sql
```

* **Run (ORM):**

  * Create `config.ini` (git-ignored):

    ```
    [db]
    username=yourusername
    password=yourpassword
    host=localhost
    database=homework08
    ```
  * `python3 olympics.py`

---

## Reproducibility

* Relative paths where possible; confirm working directory and CSV locations if imports fail.
* SQL tested on PostgreSQL; notebooks use standard Python libraries.

