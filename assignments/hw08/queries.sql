-- TODO: write the task number and description followed by the query

-- 1. Write a View 
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

-- 2. Use the Window Function, RANK()
SELECT *
FROM (
  SELECT 
    region,
    event,
    COUNT(*) FILTER (WHERE medal = 'Gold') AS gold_medals,
    RANK() OVER (
      PARTITION BY event
      ORDER BY COUNT(*) FILTER (WHERE medal = 'Gold') DESC
    ) AS rank
  FROM athlete_region
  WHERE sport = 'Fencing'
  GROUP BY region, event
) AS ranked
WHERE gold_medals > 0 AND rank <= 3
ORDER BY event, rank;

-- 3. Using Aggregate Functions as Window Functions
WITH test AS (
  SELECT 
    region, 
    year, 
    medal, 
    COUNT(medal) AS c
  FROM athlete_region
  WHERE medal IS NOT NULL
  GROUP BY region, year, medal
)
SELECT 
  region, 
  year, 
  medal, 
  c, 
  SUM(c) OVER (PARTITION BY region, medal ORDER BY year) AS rolling_sum
FROM test
ORDER BY region, year, medal;

-- 4. Use the Window Function, LAG()
WITH test AS (
  SELECT * 
  FROM athlete_region
  WHERE medal = 'Gold' AND event ILIKE '%pole vault%'
)
SELECT 
  event,
  year,
  height,
  LAG(height, 1) OVER (PARTITION BY event ORDER BY year) AS previous_height
FROM test
GROUP BY event, year, height
ORDER BY event, year;
