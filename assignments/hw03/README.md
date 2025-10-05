# Homework 03 — Data Sourcing, Summary Statistics, and Visualization

This project demonstrates basic data management and analysis using plain Python, NumPy, and Matplotlib. It involves sourcing a public dataset, cleaning and transforming data without pandas, computing summary statistics, and creating visualizations.

## Goals
- Source and document a dataset  
- Build a simple extract–transform pipeline in Python  
- Calculate descriptive statistics (mean, std, range, outliers)  
- Create data visualizations with Matplotlib  

## Research Questions
1. What were the top three leading causes of death across different racial and ethnic groups in NYC in 2010?  
2. How have cancer-related death counts changed over time by gender?  
3. What is the relationship between height and weight in U.S. adults (NHIS 2019)?

## Datasets
### NYC Leading Causes of Death
- **Source:** [NYC Open Data – Department of Health and Mental Hygiene](https://data.cityofnewyork.us/Health/New-York-City-Leading-Causes-of-Death/jb7j-dtam)  
- **Fields:** Year, Leading Cause, Sex, Race/Ethnicity, Deaths  
- **License:** Public Domain Dedication and License (PDDL)

### NHIS 2019 (Height and Weight)
- **Source:** [CDC National Health Interview Survey (NHIS) 2019](https://www.cdc.gov/nchs/nhis/2019nhis.htm)  
- **Fields:** HEIGHTTC_A (height), WEIGHTLBTC_A (weight)

## Methods
- Extracted and cleaned data using Python’s `csv` module  
- Calculated descriptive statistics with NumPy  
- Created bar and line charts with Matplotlib  
- Analyzed correlation between height and weight  

## Results
- **Top Causes (2010):** Heart disease and cancer were leading causes of death across all racial and ethnic groups.  
- **Cancer Trends (2007–2014):** Death counts increased overall for both genders, with larger variation in females.  
- **Height–Weight Correlation:** Strong positive relationship observed between height and weight in NHIS data.

## Project Structure
```

hw03/
├── README.md
├── src/
│   └── homework03.ipynb
└── data/
└── raw/
├── New_York_City_Leading_Causes_of_Death_20250215.csv
└── adult19.csv

````

## Requirements
- Python 3.x  
- NumPy  
- Matplotlib  
- Jupyter Notebook

Install dependencies:
```bash
pip install numpy matplotlib jupyter
````

## How to Run

```bash
jupyter lab
# or
jupyter notebook
```

Open `src/homework03.ipynb` and run all cells.

---

*Author: Bailey Yi*
*Course: Data Management and Analysis, NYU*

---
