# Homework 07 — ER Modeling, Joins/Subqueries, and Normalization (PostgreSQL)

Create ER diagrams from existing tables, write join/subquery/aggregation queries, stage CSV data, normalize it, and hand-write DDL.

---

## Repository Structure
```

hw07/
├─ README.md
├─ img/
│  ├─ part1_nation_subset_er_diagram.png
│  └─ part3_03_caers_er_diagram.png
└─ src/
├─ part1_notes.md                 # optional notes while inspecting tables
├─ part2_queries.sql              # answers to Part 2
├─ part3_01_create_staging.sql    # staging table
├─ part3_02_import.sql            # COPY into staging
├─ part3_03_explore.sql           # exploration queries (with pasted outputs)
└─ part4_ddl.sql                  # normalized DDL for CAERS

````

> Replace the diagram filenames if you used a different image extension.

---

## Prerequisites

- PostgreSQL 12+ (`psql` CLI)
- A database to work in (e.g., `createdb hw07`)
- The provided `nation_subset.sql` for Part 1/2
- The FDA CAERS CSV for Part 3 (Product-Based file)

---

## Part 1 — ER Diagram by Inspecting Tables

Import:
```sql
-- from psql
\i nation_subset.sql
````

Place your diagram at `img/part1_nation_subset_er_diagram.png`.

### Relationships (summary)

* **continents 1—N regions**
  *Reason:* `regions.continent_id` → `continents.continent_id`.

* **regions 1—N countries**
  *Reason:* `countries.region_id` → `regions.region_id`.

* **countries 1—N country_stats**
  *Reason:* `country_stats(country_id, year)` references `countries.country_id`.

* **countries N—M languages** via **country_languages**
  *Reason:* `country_languages.country_id` → `countries.country_id`; `country_languages.language_id` → `languages.language_id`.

* **country_languages N—1 languages** / **N—1 countries**
  *Reason:* Foreign keys noted above.

* **regions 1—1 region_areas (inferred)**
  *Reason:* `region_areas.region_name` appears to match `regions.name` (no FK declared).

---

## Part 2 — Queries (joins, subqueries, aggregation, HAVING)

All answers are in `src/part2_queries.sql`. Run:

```sql
\i src/part2_queries.sql
```

Included queries:

1. Distinct years in `country_stats` (desc)
2. First 5 country names alphabetically
3. Top 5 GDP (2018) with country name + gdp
4. Countries per `region_id` (desc)
5. Average country area per `region_id` (rounded, asc)
6. Same as (5), but `HAVING avg_area < 1000`
7. Continent population (2018) in millions (desc)
8. Countries with **no languages**
9. Top 10 countries by language count
10. Top 10 with comma-separated `languages` via `string_agg`
11. Average #languages per country by **region** (include zero-language countries)
12. Country with **oldest** and **most recent** `national_day` (single query via subqueries/UNION)

---

## Part 3 — Staging, Exploration, Normalization (FDA CAERS)

### 3.1 Staging Table

`src/part3_01_create_staging.sql`

```sql
DROP TABLE IF EXISTS staging_caers_event_product;

CREATE TABLE staging_caers_event_product (
    id SERIAL PRIMARY KEY,
    date_fda_first_received_case DATE,
    report_id TEXT,
    date_event DATE,
    product_type TEXT,
    product TEXT,
    product_code TEXT,
    description TEXT,
    patient_age NUMERIC,
    age_units VARCHAR(255),
    sex VARCHAR(255),
    case_meddra_preferred_terms TEXT,
    case_outcome TEXT
);
```

### 3.2 Import

`src/part3_02_import.sql` (adjust path/encoding as needed)

```sql
\copy staging_caers_event_product (
    date_fda_first_received_case, report_id, date_event,
    product_type, product, product_code,
    description, patient_age, age_units,
    sex, case_meddra_preferred_terms, case_outcome
)
FROM '/absolute/path/CAERS-Quarterly-20240731-CSV-PRODUCT-BASED.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'LATIN1');
```

Run:

```sql
\i src/part3_01_create_staging.sql
\i src/part3_02_import.sql
```

### 3.3 Exploration

`src/part3_03_explore.sql` contains at least 4 queries with:

* A comment describing the intent
* The SQL
* Pasted partial output (as SQL comments)
* Interpretation added in `README.md` (below)

**Findings (high-level):**

* `report_id` is **not** unique (many repeated rows).
* `product_type` has two values: `CONCOMITANT`, `SUSPECT`.
* (`report_id`, `product_type`) is **not** unique.
* (`report_id`, `product`) is **not** unique.

### 3.4 Normalized Model & ER Diagram

Place your diagram at `img/part3_03_caers_er_diagram.png`.

**Design decisions (high-level):**

* Split multi-valued comma-separated fields into related tables:

  * **MedDRA terms** → `symptoms` + `report_symptoms` (N—M)
  * **Outcomes** → `outcomes` + `report_outcomes` (N—M)
* `products` holds product-level attributes (`product`, `product_code`, `description`).
* `reports` holds event/report-level attributes (`report_id`, dates, patient fields).
* `report_products` links reports and products and carries **`product_type`**, since it varies per report–product pair.
* Composite PKs on join tables prevent duplicates (`report_id`, `meddra_term_id`) and (`report_id`, `outcome_id`).

---

## Part 4 — DDL for the Normalized Model

`src/part4_ddl.sql`

```sql
-- Products, unique by surrogate id
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product TEXT NOT NULL,
  product_code INTEGER,
  description TEXT
);

-- Reports, keyed by the external report identifier
CREATE TABLE reports (
  report_id TEXT PRIMARY KEY,
  date_event DATE,
  date_fda_first_received_case DATE,
  patient_age INTEGER,
  age_units TEXT,
  sex TEXT
);

-- Report–Product link with product_type attribute
CREATE TABLE report_products (
  report_id TEXT REFERENCES reports(report_id),
  product_id INTEGER REFERENCES products(product_id),
  product_type TEXT,
  PRIMARY KEY (report_id, product_id)
);

-- Outcomes dictionary
CREATE TABLE outcomes (
  outcome_id SERIAL PRIMARY KEY,
  outcome_description TEXT
);

-- Report–Outcome link (N—M)
CREATE TABLE report_outcomes (
  report_id TEXT REFERENCES reports(report_id),
  outcome_id INTEGER REFERENCES outcomes(outcome_id),
  PRIMARY KEY (report_id, outcome_id)
);

-- MedDRA terms dictionary
CREATE TABLE symptoms (
  meddra_term_id SERIAL PRIMARY KEY,
  term TEXT
);

-- Report–Symptom link (N—M)
CREATE TABLE report_symptoms (
  report_id TEXT REFERENCES reports(report_id),
  meddra_term_id INTEGER REFERENCES symptoms(meddra_term_id),
  PRIMARY KEY (report_id, meddra_term_id)
);
```

---

## How to Run

1. **Nation subset (Part 1/2)**

```sql
\i nation_subset.sql
\i src/part2_queries.sql
```

2. **CAERS staging/import (Part 3)**

```sql
\i src/part3_01_create_staging.sql
\i src/part3_02_import.sql
\i src/part3_03_explore.sql
```

3. **Normalized DDL (Part 4)**

```sql
\i src/part4_ddl.sql
```

---

## Notes

* The diagrams are provided as images in `img/`.
* Exploration outputs are kept short (≤10 rows) and pasted as SQL comments in `src/part3_03_explore.sql`.
* Some fields in CAERS are loosely typed on staging for convenience and are tightened in the normalized model.


