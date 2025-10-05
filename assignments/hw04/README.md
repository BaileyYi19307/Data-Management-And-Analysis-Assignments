```markdown
# Homework 04 — Pandas Basics

Two-part assignment demonstrating data import, cleaning, analysis, joins, and visualization in Pandas.

## Contents
- **Part 1 — NYC Traffic Accidents (Jan–Aug 2020):** Load and clean collision data, explore distributions, summarize injuries, visualize by borough and geolocation, and analyze monthly patterns.
- **Part 2 — Freeform Pandas Project:** Use the Central Park Squirrel Census to practice type conversion, value counts, transformations, statistics, and plotting.

## Datasets
### NYC Traffic Accidents (2020 Jan–Aug)
- **Source:** NYC Open Data snapshot via Kaggle (Motor Vehicle Collisions)
- **File:** `data/raw/NYC_Accidents_2020.csv`  
- **Note:** The file header begins on row 4 (`pd.read_csv(..., header=3)`).

**Fields used (subset):**  
`CRASH DATE`, `CRASH TIME`, `BOROUGH`, `ON STREET NAME`, `LATITUDE`, `LONGITUDE`,  
`NUMBER OF PERSONS INJURED`, `NUMBER OF PERSONS KILLED`,  
`NUMBER OF PEDESTRIANS INJURED/KILLED`, `NUMBER OF CYCLIST INJURED/KILLED`,  
`NUMBER OF MOTORIST INJURED/KILLED`

### 2018 Central Park Squirrel Census
- **Source:** NYC Open Data — The Squirrel Census  
- **About:** https://data.cityofnewyork.us/Environment/2018-Central-Park-Squirrel-Census-Squirrel-Data/vfnx-vebw/about_data  
- **File:** `data/raw/2018_Central_Park_Squirrel_Census_-_Squirrel_Data_20250227.csv`

**Fields used (subset):**  
`Primary Fur Color`, `Above Ground Sighter Measurement`, `Date`, `X` (lon), `Y` (lat), `Location`

## Methods

### Part 1 — Traffic Accidents
- **Import & Fixes:** `pd.read_csv(..., header=3)`. Converted `CRASH DATE`/`CRASH TIME` to datetime; standardized `BOROUGH` and `ON STREET NAME` to uppercase; categorized non-core boroughs and missing values as `OTHER`.
- **Cleaning:** Removed columns with near-complete missingness or not needed for tasks (e.g., extra contributing factor fields, vehicle type 3–5). Dropped rows with invalid or missing geocoordinates; removed `(0, 0)` points.
- **Exploration:**
  - Top streets by collision count (`value_counts` on `ON STREET NAME`)
  - Collisions by borough (bar chart)
  - Summary stats for `NUMBER OF PERSONS INJURED` for NYC overall and selected boroughs (mean, median, quartiles, min/max)
  - Scatter plot of accidents by latitude/longitude colored by borough
  - Covariance matrix for selected severity/location columns
  - Monthly accident counts (derived from `CRASH DATE`, labeled with `calendar.month_abbr`)
- **Documentation:** Each step is preceded by a markdown cell mirroring the assignment instruction.

### Part 2 — Squirrel Census
- **Import & Types:** `read_csv`, `Date` → `datetime` (`%m%d%Y`), rename `Location` → `AboveOrBelowGround`.
- **Analysis Operations:**
  - Value counts: `Primary Fur Color` (bar plot)
  - Date-derived counts: most common day
  - Filtering and stats: mean of `Above Ground Sighter Measurement` for above-ground sightings
  - Geospatial scatter of sightings using `X` (lon) and `Y` (lat)

## Results (high level)
- **Borough distribution:** Clear differences in collision counts by borough; `OTHER` captures missing/unknown.
- **Injury severity:** Median injuries per crash are zero for NYC and sampled boroughs; Brooklyn shows higher mean and variance than Manhattan in this slice.
- **Geolocation:** Borough-colored scatter reveals expected spatial clustering.
- **Monthly pattern:** Winter months show higher counts than spring in this subset.
- **Squirrels:** Gray and brown are the most frequent fur colors; a single day in October dominates reported sightings; above-ground sightings have a measurable mean height; sightings cluster spatially within the park.

## Project Structure
```

hw04/
├── README.md
├── src/
│   ├── traffic_accidents.ipynb
│   └── project.ipynb
└── data/
└── raw/
├── NYC_Accidents_2020.csv
└── 2018_Central_Park_Squirrel_Census_-_Squirrel_Data_20250227.csv

````

## Requirements
- Python 3.x
- pandas
- numpy
- matplotlib
- jupyter

Install:
```bash
pip install pandas numpy matplotlib jupyter
````

## How to Run

```bash
jupyter lab
# or
jupyter notebook
```

Open `src/traffic_accidents.ipynb` and `src/project.ipynb`, run all cells from top to bottom.

```

