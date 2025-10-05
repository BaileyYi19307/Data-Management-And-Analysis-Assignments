-- write your queries underneath each number:
 -- 1. the total number of rows in the database
SELECT COUNT(id) FROM squirrel_data;

-- 2. show the first 15 rows, but only display 3 columns (your choice)
SELECT primary_fur_color, date, longitude
FROM squirrel_data
WHERE id <= 15;

-- 3. same as above, but sorted by longitude in descending order
SELECT primary_fur_color, date, longitude
FROM squirrel_data
WHERE id <= 15
ORDER BY longitude DESC;

-- 4. add a new column without a default value
ALTER TABLE squirrel_data ADD COLUMN test_column INTEGER;

-- 5. set the value of that new column
UPDATE squirrel_data SET test_column = 1;

-- 6. show only the unique (non-duplicate) values of a column
SELECT DISTINCT primary_fur_color FROM squirrel_data;

-- 7. group rows by primary fur color and count how many per group
SELECT primary_fur_color, COUNT(*) 
FROM squirrel_data
GROUP BY primary_fur_color;

-- 8. same as above, but filter groups with at least 200 squirrels
SELECT primary_fur_color, COUNT(*) 
FROM squirrel_data
GROUP BY primary_fur_color
HAVING COUNT(*) >= 200;

-- 9. What’s the max height a squirrel was sighted above ground?
SELECT MAX(above_ground_sighter_measurement) 
FROM squirrel_data;

-- 10. What’s the mean height that squirrels were sighted above ground?
SELECT AVG(above_ground_sighter_measurement) 
FROM squirrel_data;

-- 11. How many squirrels were seen above ground?
SELECT COUNT(above_or_below_ground) 
FROM squirrel_data
WHERE above_or_below_ground = 'Above Ground';

-- 12. What day were most squirrels sighted?
SELECT date, COUNT(*) AS sighting_count 
FROM squirrel_data
GROUP BY date
ORDER BY sighting_count DESC
LIMIT 1;
