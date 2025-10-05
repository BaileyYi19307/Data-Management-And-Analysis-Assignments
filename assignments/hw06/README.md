
# Homework 06 — Single Table, CSV Import, and SQL (PostgreSQL)

Load a cleaned CSV into PostgreSQL, design a single-table schema, and run queries for basic analysis.

## Contents
- **Data prep:** Convert raw NYC Open Data (Squirrel Census) to a clean CSV
- **Schema:** Single-table design with appropriate types and a surrogate primary key
- **Import:** Client-side `\copy` into PostgreSQL
- **Queries:** Row counts, selects with sort, distincts, group-by + having, and custom insights

## Dataset
- **Title:** 2018 Central Park Squirrel Census — Squirrel Data  
- **Source:** NYC Open Data (The Squirrel Census)  
- **Records:** 3,023  
- **Fields used:** `Primary Fur Color`, `Above Ground Sighter Measurement`, `Date`, `X` (Longitude), `Y` (Latitude), `Location`

## Methods
### Conversion (→ `squirrel_census.csv`)
- Keep relevant columns; rename for clarity:
  - `X` → `Longitude`, `Y` → `Latitude`, `Location` → `AboveOrBelowGround`
- Normalize values (e.g., `"FALSE"` → `0` for height)
- Parse `Date` (`%m%d%Y`) to SQL `DATE`
- Export to CSV without index

### Schema (→ `create_table.sql`)
```sql
DROP TABLE IF EXISTS squirrel_data;
CREATE TABLE squirrel_data (
    id SERIAL PRIMARY KEY,
    primary_fur_color TEXT,
    above_ground_sighter_measurement INT,
    date DATE,
    longitude FLOAT,
    latitude FLOAT,
    above_or_below_ground TEXT
);
````

**Design notes:** Surrogate `id` key; allow NULLs where the source has missing values; geographic fields stored as `FLOAT`; dates stored as `DATE`.

### Import (→ `import_csv.sql`)

Client-side import to avoid server path issues:

```sql
\copy squirrel_data(
    primary_fur_color,
    above_ground_sighter_measurement,
    date,
    longitude,
    latitude,
    above_or_below_ground
)
FROM 'squirrel_census.csv'
DELIMITER ','
CSV HEADER;
```

### Queries (→ `queries.sql`)

Covers:

* Total row count
* First 15 rows (3 columns), then sorted
* Add and update a new column
* Distinct values
* Group + aggregate (counts)
* Group filtering with `HAVING`
* Additional insights:

  * Max and average height above ground
  * Count of “Above Ground” sightings
  * Busiest sighting date

## Project Structure

```
hw06/
├── README.md
├── convert.ipynb
├── squirrel_census.csv
├── create_table.sql
├── import_csv.sql
└── queries.sql
```

## Requirements

* PostgreSQL 12+ (server and `psql` client)
* Python 3.x (for conversion)
* Jupyter (optional, to run the notebook)

Install (macOS example):

```bash
brew install postgresql
brew services start postgresql
```

## How to Run

1. **Create database**

   ```bash
   createdb homework06
   psql homework06
   ```
2. **Create table**

   ```sql
   \i create_table.sql
   ```
3. **Import CSV**

   ```sql
   \i import_csv.sql
   ```
4. **Run queries**

   ```bash
   psql homework06 -f queries.sql
   ```

   or inside `psql`:

   ```sql
   \i queries.sql
   ```

## Results

* ~3k rows imported successfully with `\copy`.
* Grouped counts by fur color and computed height statistics.
* Identified the most active sighting date.

```
```
