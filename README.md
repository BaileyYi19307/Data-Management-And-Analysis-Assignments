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
│  ├─ data/raw/...
│  └─ README.md
├─ hw04/               # Pandas basics + freeform pandas project
│  ├─ src/traffic_accidents.ipynb
│  ├─ src/project.ipynb
│  ├─ data/raw/...
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

> Large/raw datasets may be excluded per platform size limits; each sub-README specifies source links and import instructions.

---

## Quick Start

### Python
```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt  # if present; else install per sub-README
jupyter lab
````

### PostgreSQL

```bash
# Start server, then for each assignment that uses SQL:
psql -U <user> -h localhost
```

---

## Assignment Summaries

### HW03 — Sourcing Data, Summary Stats, Basic Visualization

* **Focus:** Select and document a real dataset; plain Python ETL; numpy stats; matplotlib visuals; correlation and scatter
* **Artifacts:** `src/homework03.ipynb`, `data/raw/…`
* **Highlights:**

  * End-to-end pipeline without pandas (csv module, type conversion, cleaning).
  * Summary statistics (mean, std, range, IQR) and frequency tables.
  * Visuals: bar charts, line plots, scatter with transparency.
* **Run:** Open the notebook and run all cells; paths are relative to `data/raw`.

---

### HW04 — Pandas Basics

* **Focus:** SV import with dtype fixes; exploratory analysis; grouping; joins; visuals.
* **Artifacts:** `src/traffic_accidents.ipynb` (NYC collisions 2020), `src/project.ipynb` (freeform analysis).
* **Highlights:**

  * Fixed malformed headers (`read_csv(..., header=3)` pattern).
  * Cleaning: column drops, datetime parsing, standardizing categorical values.
  * Borough-level accident counts and geospatial scatter by borough.
  * Freeform project: Central Park Squirrel Census—type conversion, value counts, summary stats, and plots.
* **Run:** Open notebooks; ensure raw CSVs are in `data/raw`. Execute cells top-to-bottom.

---

### HW05 — Data from the Web & Combining Data

* **Focus:** HTML parsing (requests + BeautifulSoup), `merge` joins, and JSON/API ingestion in one notebook.
* **Artifacts:** `courses.ipynb`
* **Highlights:**

  * Parsed course schedule and catalog HTML; cleaned zero-width spaces; handled multi-instructor cases.
  * Merged schedule with catalog on course number; left-join to preserve all scheduled classes.
  * API section (Studio Ghibli films): JSON → DataFrame → grouped report (directors, film counts, average RT score).
* **Run:** Open the notebook; place saved HTML files at repo root; ensure internet or mirrored JSON if required.

---

### HW06 — Single Table, Importing Data, SQL

* **Focus:** Design a single-table schema; import CSV; query fundamentals; reporting.
* **Artifacts:** `convert.ipynb`, `create_table.sql`, `import_csv.sql`, `queries.sql`, `report.md`
* **Dataset:** 2018 Central Park Squirrel Census (cleaned to `squirrel_census.csv`).
* **Highlights:**

  * Table: `squirrel_data` (serial PK, typed columns).
  * Import via `\copy` (server vs client path clarified).
  * Queries: counts, projections with sort, distincts, group/having, additional analytics (max/avg heights, busiest day).
* **Run:**

  ```sql
  createdb homework06
  \c homework06
  \i create_table.sql
  \i import_csv.sql
  \i queries.sql
  ```

  Results are summarized in `report.md`.

---

### HW07 — ER Diagramming, Joins/Subqueries, Normalization

* **Focus:** Inspect an existing multi-table dataset; write queries; normalize a separate CSV into 3NF; author DDL.
* **Artifacts:**

  * Part 1 ERD: `img/part1_nation_subset_er_diagram.png` + relationships documented in README.
  * Part 2 SQL: `src/part2_queries.sql` (years, top GDP, region counts, averages, language counts, string_agg lists, subqueries).
  * Part 3 Staging + Exploration: `src/part3_01_create_staging.sql`, `src/part3_02_import.sql`, `src/part3_03_explore.sql`, ERD `img/part3_03_caers_er_diagram.png`.
  * Part 4 DDL: `src/part4_ddl.sql`.
* **Highlights:**

  * Clear one-to-many and many-to-many mappings; explicit join tables.
  * CAERS staging table → normalized model (reports, products, symptoms/MedDRA, outcomes, link tables).
  * Exploration queries to identify candidate keys and multi-valued fields (atomicity violations).
* **Run:** Execute SQL files in order; diagrams are static images for review.

---

### HW08 — Window Functions, Views, Indexing, SQLAlchemy

* **Focus:** Olympic dataset; views; `RANK()`, `LAG()`, running totals; EXPLAIN/ANALYZE + index; SQLAlchemy ORM.
* **Artifacts:** `create.sql`, `queries.sql`, `explain_analyze.sql`, `olympics.py`
* **Highlights:**

  * View `athlete_region` to normalize region names when NOC lookup is missing.
  * Window queries: top-3 fencing regions by golds; rolling medal sums; pole vault gold `LAG(height)`.
  * Performance: baseline scan vs indexed lookup on `name`.
  * ORM: mapped `AthleteEvent` / `NOCRegion`, inserted 2020 Yuto Horigome record; parameterized query for JPN golds ≥ 2016.
* **Run:**

  ```sql
  createdb homework08
  \c homework08
  \i create.sql
  \copy noc_region FROM 'noc_regions.csv' WITH CSV HEADER NULL 'NA'
  \copy athlete_event (...) FROM 'athlete_events.csv' WITH CSV HEADER NULL 'NA'
  \i queries.sql
  \i explain_analyze.sql
  ```

  For ORM:

  * Create `config.ini` (excluded from git):

    ```
    [db]
    username=yourusername
    password=yourpassword
    host=localhost
    database=homework08
    ```
  * Run: `python3 olympics.py`

---

## Notes on Reproducibility

* Relative paths are used where possible. If imports fail, confirm working directory and CSV locations.
* Some CSVs are large; fetch from the linked sources if not included.
* All SQL is ANSI-friendly and tested in PostgreSQL.

---

