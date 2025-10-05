
--1. Show the possible values of the year column in the country_stats table sorted by most recent year first.
SELECT DISTINCT year
FROM country_stats
ORDER BY year DESC;

--2. Show the names of the first 5 countries in the database when sorted in alphabetical order by name.
select name from countries order by name;


--3. Adjust the previous query to show both the country name and the gdp from 2018, but this time show the top 5 countries by gdp.
SELECT name, gdp
FROM countries
INNER JOIN country_stats ON countries.country_id = country_stats.country_id
WHERE year = 2018
ORDER BY gdp DESC
LIMIT 5;

--4. How many countries are associated with each region id?
SELECT region_id, COUNT(*) AS country_count
FROM countries
GROUP BY region_id
ORDER BY country_count DESC;

-- 5. What is the average area of countries in each region id?
SELECT
  region_id,
  ROUND(AVG(area)) AS avg_area
FROM
  countries
GROUP BY
  region_id
ORDER BY
  avg_area ASC;

--6. Use the same query as above, but only show the groups with an average country area less than 1000
SELECT
  region_id,
  ROUND(AVG(area)) AS avg_area
FROM
  countries
GROUP BY
  region_id
HAVING
  ROUND(AVG(area)) < 1000
ORDER BY
  avg_area ASC;

--7. Create a report displaying the name and population of every continent in the database from the year 2018 in millions.
SELECT con.name, ROUND(SUM(cs.population) / 1000000.0, 2) AS tot_pop
FROM continents con
JOIN regions r ON con.continent_id = r.continent_id
JOIN countries c ON r.region_id = c.region_id
JOIN country_stats cs ON c.country_id = cs.country_id
WHERE cs.year = 2018
GROUP BY con.name
ORDER BY tot_pop DESC;

--8. List the names of all of the countries that do not have a language.
SELECT c.name
FROM countries c
LEFT JOIN country_languages cl ON c.country_id = cl.country_id
WHERE cl.language_id IS NULL;

--9. Show the country name and number of associated languages of the top 10 countries with most languages
SELECT c.name, COUNT(cl.language_id) AS lang_count
FROM countries c
JOIN country_languages cl ON c.country_id = cl.country_id
GROUP BY c.name
ORDER BY lang_count DESC
LIMIT 10;

--10. Repeat your previous query, but display a comma separated list of spoken languages rather than a count (use the aggregate function for strings, string_agg. A single example row (note that results before and above have been omitted for formatting):
SELECT c.name, STRING_AGG(l.language, ',') 
FROM countries c
JOIN country_languages cl ON c.country_id = cl.country_id
JOIN languages l ON cl.language_id = l.language_id
GROUP BY c.name
ORDER BY COUNT(*) DESC
LIMIT 10;

--11. What's the average number of languages in every country in a region in the dataset? Show both the region's name and the average. Make sure to include countries that don't have a language in your calculations. (Hint: using your previous queries and additional subqueries may be useful)

SELECT r.name AS name, ROUND(AVG(lang_count)::numeric, 1) AS avg_lang_count_per_country
FROM (
    SELECT c.region_id, COUNT(cl.language_id) AS lang_count
    FROM countries c
    LEFT JOIN country_languages cl ON c.country_id = cl.country_id
    GROUP BY c.country_id, c.region_id
) sub
JOIN regions r ON sub.region_id = r.region_id
GROUP BY r.name
ORDER BY avg_lang_count_per_country DESC;


--12. 
(
    SELECT name, national_day
    FROM countries
    WHERE national_day = (SELECT MIN(national_day) FROM countries WHERE national_day IS NOT NULL)
)
UNION
(
    SELECT name, national_day
    FROM countries
    WHERE national_day = (SELECT MAX(national_day) FROM countries WHERE national_day IS NOT NULL)
);
