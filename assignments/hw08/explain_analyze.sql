-- 1. Drop an existing index
DROP INDEX IF EXISTS athlete_event_name_idx;

-- 2. Simple query to find all rows for the athlete Michael Fred Phelps, II
SELECT * FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';

-- 3. EXPLAIN ANALYZE to observe performance (before index)
EXPLAIN ANALYZE
SELECT * FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';

-- Gather  (cost=1000.00..8219.36 rows=63 width=137) (actual time=23.596..33.901 rows=30 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on athlete_event  
--       (cost=0.00..7213.06 rows=26 width=137) 
--       (actual time=20.348..25.657 rows=10 loops=3)
--         Filter: (name = 'Michael Fred Phelps, II'::text)
--         Rows Removed by Filter: 90362
-- Planning Time: 0.337 ms
-- Execution Time: 33.943 ms

-- 4. Add an index on the name column
CREATE INDEX athlete_event_name_idx ON athlete_event (name);

-- 5. A query that avoids using the index (with ILIKE)
EXPLAIN ANALYZE
SELECT * FROM athlete_event
WHERE name ILIKE '%Michael Fred Phelps, II%';

-- Gather  (cost=1000.00..8222.06 rows=90 width=137) (actual time=38.808..50.367 rows=30 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on athlete_event  
--       (cost=0.00..7213.06 rows=38 width=137) 
--       (actual time=35.057..41.918 rows=10 loops=3)
--         Filter: (name ~~* '%Michael Fred Phelps, II%'::text)
--         Rows Removed by Filter: 90362
-- Planning Time: 0.343 ms
-- Execution Time: 50.405 ms
