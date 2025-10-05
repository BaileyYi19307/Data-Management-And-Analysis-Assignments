# Overview
1. Name / Title: 2018 Central Park Squirrel Census - Squirrel Data
2. Link to Data: https://data.cityofnewyork.us/Environment/2018-Central-Park-Squirrel-Census-Squirrel-Data/vfnx-vebw/about_data
3. Source / Origin: 
	* Author or Creator: The Squirrel Census
	* Publication Date: October 13, 2019
	* Publisher: NYC Open Data
	* Version or Data Accessed: Feb 27, 2025
4. License: Unspecified

Format: CSV
Size: 748 KB
Number of Records: 3023

Fields or Column Headers
* Field/Column 1: Primary Fur Color - string
* Field/Column 2: Above Ground Sighter Measurement - float
* Field/Column 3: Date - DateTime
* Field/Column 4: Longitude - float
* Field/Column 5: Latitude - float
* Field/Column 6: AboveOrBelowGround - string 

# Table Design

primary_fur_color: Text field, but allow nulls due to missing values in the dataset

above_ground_sighter_measurement:  INT to represent inches above ground. Nulls are allowed where data is missing

date: SQL DATE format. Some entries may be incomplete, so nulls are allowed

longitude and latitude: Geographic fields as FLOAT, some entries have missing coordinates, so nulls are allowed

above_or_below_ground: Stored as text with possible values like 'Above Ground', 'Ground Plane', or null. Since not all records contain this (missing info), nulls are allowed

# Import
ERROR:  could not open file "/Users/baileyyi/hw6/homework06-BaileyYi19307/squirrel_census.csv /tmp/squirrel_census.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.

fixed by using \copy 

# Database Information
1. homework06=# \l
                             List of databases
    Name    |  Owner   | Encoding | Collate | Ctype |   Access privileges   
------------+----------+----------+---------+-------+-----------------------
 homework06 | baileyyi | UTF8     | C       | C     | 
 postgres   | baileyyi | UTF8     | C       | C     | 
 template0  | baileyyi | UTF8     | C       | C     | =c/baileyyi          +
            |          |          |         |       | baileyyi=CTc/baileyyi
 template1  | baileyyi | UTF8     | C       | C     | =c/baileyyi          +
            |          |          |         |       | baileyyi=CTc/baileyyi
(4 rows)

2. homework06=# \dt
             List of relations
 Schema |     Name      | Type  |  Owner   
--------+---------------+-------+----------
 public | squirrel_data | table | baileyyi
(1 row)

3. homework06=# \d squirrel_data
                                              Table "public.squirrel_data"
              Column              |       Type       | Collation | Nullable |                  Default                  
----------------------------------+------------------+-----------+----------+-------------------------------------------
 id                               | integer          |           | not null | nextval('squirrel_data_id_seq'::regclass)
 primary_fur_color                | text             |           |          | 
 above_ground_sighter_measurement | integer          |           |          | 
 date                             | date             |           |          | 
 longitude                        | double precision |           |          | 
 latitude                         | double precision |           |          | 
 above_or_below_ground            | text             |           |          | 
Indexes:
    "squirrel_data_pkey" PRIMARY KEY, btree (id)



# Query Results

```
### 1. the total number of rows in the database		
 count 
-------
  3023
(1 row)
```

```
### 2. show the first 15 rows, but only display 3 columns (your choice)
 primary_fur_color |    date    |     longitude     
-------------------+------------+-------------------
                   | 2018-10-14 | -73.9561344937861
                   | 2018-10-19 | -73.9688574691102
 Gray              | 2018-10-14 | -73.9742811484852
 Gray              | 2018-10-17 | -73.9596413903948
 Gray              | 2018-10-17 | -73.9702676472613
 Cinnamon          | 2018-10-10 | -73.9683613516225
 Gray              | 2018-10-10 | -73.9541201789795
 Gray              | 2018-10-08 | -73.9582694312289
 Gray              | 2018-10-06 | -73.9674285955293
 Gray              | 2018-10-10 | -73.9722500196844
 Gray              | 2018-10-13 | -73.9695063535333
 Gray              | 2018-10-14 | -73.9640032826529
 Gray              | 2018-10-07 | -73.9532170504865
 Cinnamon          | 2018-10-10 | -73.9768603630674
 Gray              | 2018-10-06 | -73.9706105896967
```

```
### 3. do the same as above, but chose a column to sort on, and sort in descending order
 primary_fur_color |    date    |     longitude     
-------------------+------------+-------------------
 Gray              | 2018-10-07 | -73.9532170504865
 Gray              | 2018-10-10 | -73.9541201789795
                   | 2018-10-14 | -73.9561344937861
 Gray              | 2018-10-08 | -73.9582694312289
 Gray              | 2018-10-17 | -73.9596413903948
 Gray              | 2018-10-14 | -73.9640032826529
 Gray              | 2018-10-06 | -73.9674285955293
 Cinnamon          | 2018-10-10 | -73.9683613516225
                   | 2018-10-19 | -73.9688574691102
 Gray              | 2018-10-13 | -73.9695063535333
 Gray              | 2018-10-17 | -73.9702676472613
 Gray              | 2018-10-06 | -73.9706105896967
 Gray              | 2018-10-10 | -73.9722500196844
 Gray              | 2018-10-14 | -73.9742811484852
 Cinnamon          | 2018-10-10 | -73.9768603630674	
```


```
### 4. add a new column without a default value
```
ALTER TABLE
```
### 5. set the value of that new column
UPDATE 3023
```

```
### 6. show only the unique (non duplicates) of a column of your choice
 primary_fur_color 
-------------------
 
 Gray
 Black
 Cinnamon
(4 rows)
```

```
### 7. group rows together by a column value (your choice) and use an aggregate function to calculate something about that group (count of all members of the group, the average of a column of the members of the group)
 primary_fur_color | count 
-------------------+-------
                   |    55
 Gray              |  2473
 Black             |   103
 Cinnamon          |   392
```

```
### 8. now, using the same grouping query or creating another one, find a way to filter the query results based on the values for the groups (for example, show all genres that have more than 2 movies in it and only show the genre and the number of movies for that genre).
you'll use a HAVING clause to do this (covered in the slides on group by)
 primary_fur_color | count 
-------------------+-------
 Gray              |  2473
 Cinnamon          |   392
(2 rows)
	
```

```
### 9. What’s the max height a squirrel was sighted above ground? 
 max 
-----
 180
(1 row)
```

```
### 10. What’s the mean height that squirrels were sighted above ground? 
        avg         
--------------------
 4.1464420763148848
(1 row)
```

```
### 11. How many squirrels were seen above ground? 
 count 
-------
   843
(1 row)
```

```
### 12. What day were most squirrels sighted?
    date    | sighting_count 
------------+----------------
 2018-10-13 |            434
(1 row)
```