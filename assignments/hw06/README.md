# Homework 05 — Data from the Web & Combining Data

Single-notebook project that:
- Parses saved HTML for the semester **course schedule** and **course catalog**, cleans fields, and **merges** by course number.
- Retrieves paginated **JSON** (Studio Ghibli films), loads to pandas, and **aggregates** by director (average Rotten Tomatoes score, film count).

## Files
- `courses.ipynb` — contains both parts (courses + films)
- `course_schedule.html` — saved schedule page (input)
- `course_catalog.html` — saved catalog page (input)

## Datasets
### Course Schedule & Catalog (HTML)
- **Inputs:** `course_schedule.html`, `course_catalog.html`
- **Fields used (subset):**  
  - Schedule: `Number-Section`, `Name`, `Instructor`, `Time`  
  - Catalog: `Number`, `Prereqs`, `Points`

### Studio Ghibli Films (JSON)
- **Endpoint (paginated):** `.../films?_page=1`  
- **Fields used (subset):** `title`, `director`, `rt_score`

## Methods
### Courses (HTML → DataFrames → Merge)
- HTML parsed with **BeautifulSoup** (`select`, `select_one`).
- Cleaning:
  - Remove zero-width spaces in course numbers (`.replace('\u200b','')`).
  - Split `Number-Section` → `Number` (e.g., `CSCI-UA.0480`) and `Section` (e.g., `001`) via regex extract.
  - Normalize instructor strings; handle multi-number rows by duplicating.
- Merge catalog metadata (`Prereqs`, `Points`) via `pd.merge(..., on='Number', how='left')`.
- Output columns: `Number`, `Name`, `Instructor`, `Time`, `Prereqs`, `Points`.

### Films (JSON API → DataFrame → Aggregation)
- Paginate with `requests.get(...).json()` until empty page; concat to a single DataFrame.
- Convert `rt_score` to numeric and `groupby('director')` to compute:
  - `avg_rt_score` (mean)
  - `film_count` (size)
- Sort by `film_count` and `avg_rt_score`.

## Results (high level)
- **Courses:** Left join preserves all scheduled classes and attaches `Prereqs`/`Points` where available; standardized identifiers enable a clean merge.
- **Films:** Director-level table showing number of films and average Rotten Tomatoes scores derived from the paginated JSON.

## Project Structure
```

hw05/
├── README.md
├── courses.ipynb
├── course_schedule.html
└── course_catalog.html

````

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

Open `courses.ipynb` and run all cells from top to bottom.

```
