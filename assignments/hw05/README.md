# Homework 05 — Data from the Web & Combining Data (Single Notebook)

Single notebook that:
1) Parses saved HTML for the course **schedule** and **catalog**, cleans fields, and **merges** by course number.  
2) Requests paginated **JSON** (Studio Ghibli films), loads to pandas, and **aggregates** by director (average RT score, film count).

## Files
- `courses.ipynb` — contains **both** parts (courses + films)
- `course_schedule.html` — saved semester schedule page (input)
- `course_catalog.html` — saved catalog page (input)

## Methods (high level)
### Courses (HTML → DataFrame → Merge)
- **Parse:** `BeautifulSoup` (`select`, `select_one`) to extract rows and fields.
- **Clean:**
  - Remove zero-width spaces in course numbers: `s.replace('\u200b','')`
  - Split `Number-Section` → `Number` (e.g., `CSCI-UA.0480`) and `Section` (e.g., `001`) via regex:  
    `df[['Number','Section']] = df['Number-Section'].str.extract(r'(.*)-(\d{3})')`
  - Normalize instructor strings; duplicate rows for multi-number courses (documented in notebook).
- **Catalog Frame:** Extract `Number`, `Prereqs`, `Points`.
- **Merge:** `pd.merge(schedule_df, catalog_df, on='Number', how='left')` and select  
  `['Number','Name','Instructor','Time','Prereqs','Points']`.

### Films (JSON API → DataFrame → Aggregation)
- **Pagination:** loop `_page` until empty result; append to list → DataFrame.
- **Aggregation:** convert `rt_score` to numeric; group by `director` → `avg_rt_score`, `film_count`; sort by `film_count` then `avg_rt_score`.

## Results (summary)
- **Courses:** Left join keeps all scheduled classes; `Prereqs`/`Points` attach where present; zero-width spaces and multi-number cases handled.
- **Films:** Director-level table with number of films and average Rotten Tomatoes scores.

## Requirements
- Python 3.x
- pandas
- requests
- beautifulsoup4
- lxml
- jupyter

Install:
```bash
pip install pandas requests beautifulsoup4 lxml jupyter
````

## How to Run

```bash
jupyter lab
# or
jupyter notebook
```

Open **`courses.ipynb`** and run all cells from top to bottom.



