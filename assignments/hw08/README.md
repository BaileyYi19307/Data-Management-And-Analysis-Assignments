# Homework 08 — Windows, Views, Indexing, and SQLAlchemy (Olympics)

A PostgreSQL + Python (SQLAlchemy) exercise using the Kaggle Olympic history dataset (1896–2016). Work includes importing CSVs, creating a view, writing window-function queries, profiling with `EXPLAIN ANALYZE` and indexes, and interacting with the database via SQLAlchemy ORM.

---

## Repository Structure

```

hw08/
├─ README.md
├─ create.sql
├─ queries.sql
├─ explain_analyze.sql
├─ olympics.py
├─ .gitignore               # ensures config.ini is ignored
├─ athlete_events.csv       # not committed if large
└─ noc_regions.csv          # not committed if large

````

---

## Data Import (Part 1)

1) Create the database:
```bash
createdb homework08
````

2. Create tables:

```sql
\c homework08
\i create.sql
```

`create.sql` drops and recreates:

* `noc_region(noc PRIMARY KEY, region, note)`
* `athlete_event(athlete_event_id SERIAL PRIMARY KEY, id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal)`

3. Import CSVs (treat `NA` as NULL; single-line `\copy`):

```sql
\copy noc_region FROM 'noc_regions.csv' WITH CSV HEADER NULL 'NA'
\copy athlete_event (id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal)
FROM 'athlete_events.csv' WITH CSV HEADER NULL 'NA'
```

---

## Views and Window Functions (Part 2)

All SQL is in `queries.sql`.

### 1) View for later queries

Creates a convenience view that joins NOC info and normalizes missing regions:

* If `noc_region.region` is missing:

  * `SGP` → `Singapore`
  * `ROT`, `TUV`, `UNK` → use `team`
* Otherwise, use `noc_region.region`.

```sql
CREATE OR REPLACE VIEW athlete_region AS
SELECT 
  ae.*,
  COALESCE(
    nr.region,
    CASE
      WHEN ae.noc = 'SGP' THEN 'Singapore'
      WHEN ae.noc IN ('ROT', 'TUV', 'UNK') THEN ae.team
      ELSE NULL
    END
  ) AS region
FROM athlete_event ae
LEFT JOIN noc_region nr ON ae.noc = nr.noc;
```

### 2) Top 3 regions per fencing event by gold medals (window `RANK()`)

* Partition by `event`, rank by gold-medal count desc.
* Output: `region, event, gold_medals, rank`
* Ordered by `event, rank`.

### 3) Rolling sum of medals per region/year/medal (aggregate as window)

* Group to get annual counts, then compute running totals.
* Output: `region, year, medal, c, sum`
* Partition by `(region, medal)`, ordered by `year`.

### 4) Previous gold medalist’s height for pole vault (window `LAG()`)

* Filter gold medalists for events matching `%pole vault%`.
* Output: `event, year, height, previous_height` (`LAG(height)` by `event`).

---

## EXPLAIN / ANALYZE and Indexes (Part 3)

All steps in `explain_analyze.sql`.

1. Drop index if present:

```sql
DROP INDEX IF EXISTS athlete_event_name_idx;
```

2. Baseline query for exact name match:

```sql
SELECT * FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';
```

3. Profile with `EXPLAIN ANALYZE` (before index).

4. Create index:

```sql
CREATE INDEX athlete_event_name_idx ON athlete_event (name);
```

5. Profile again with `EXPLAIN ANALYZE` (after index) and confirm `Index Scan`.

6. Show a case where planner avoids the index (e.g., `ILIKE '%...%'`) and profile with `EXPLAIN ANALYZE`.

---

## SQLAlchemy ORM (Part 4)

### Configuration

Create `config.ini` in repo root (ensure it’s **ignored** by git):

```
[db]
username=yourusername
password=yourpassword
host=localhost
database=homework08
```

### Models

Defined in `olympics.py`:

* `NOCRegion(noc PK, region, note)` with relationship `athlete_events`
* `AthleteEvent(athlete_event_id PK, …, noc FK-like)` with relationship `noc_region`

`__str__`/`__repr__` return concise, readable strings including `name, noc, season, year, event, medal`.

### Insert Example

Adds 2020 Men’s Street Skateboarding gold result for Yuto Horigome:

* `name='Yuto Horigome', age=21, team='Japan', medal='Gold', year=2020, season='Summer', city='Tokyo', noc='JPN', sport='Skateboarding', event='Skateboarding, Street, Men'`

### Query Example

Select all `AthleteEvent` with:

* `noc = 'JPN'`
* `year >= 2016`
* `medal = 'Gold'`

Iterates and prints: `name, region (via noc_region), event, year, season`.

Run:

```bash
python3 olympics.py
```

---

## How to Reproduce

1. DB and tables

```sql
\c homework08
\i create.sql
```

2. Import data

```sql
\copy noc_region FROM 'noc_regions.csv' WITH CSV HEADER NULL 'NA'
\copy athlete_event (id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal)
FROM 'athlete_events.csv' WITH CSV HEADER NULL 'NA'
```

3. Views & window functions

```sql
\i queries.sql
```

4. Performance & indexing

```sql
\i explain_analyze.sql
```

5. ORM

* Create `config.ini`
* Run `python3 olympics.py`

---

## Notes

* CSVs are large; keep them out of version control if necessary.
* Window functions rely on clean `year/medal` values; `NA` is imported as `NULL`.
* The `athlete_event` → `noc_region` link is via `noc` and may be missing; the view normalizes these cases.

