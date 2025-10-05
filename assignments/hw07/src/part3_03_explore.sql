-- 1. check whether or not report_id is unique
SELECT report_id, COUNT(*) AS count
FROM staging_caers_event_product
GROUP BY report_id
ORDER BY count DESC
LIMIT 10;

--     report_id    | count 
-- -----------------+-------
--  179852          |    44
--  174049          |    39
--  117851          |    39
--  141218          |    36
--  210074          |    35
--  190041          |    35
--  2020-CFS-008964 |    32
--  104496          |    31
--  153719          |    31
--  190166          |    30
-- (10 rows)


-- 2. check the distinct values in the product_type column
SELECT DISTINCT product_type
FROM staging_caers_event_product;

--  product_type 
-- --------------
--  CONCOMITANT
--  SUSPECT
-- (2 rows)


-- 3. check whether the combination of report_id and product_type is unique
SELECT report_id, product_type, COUNT(*) AS count
FROM staging_caers_event_product
GROUP BY report_id, product_type
ORDER BY count DESC
LIMIT 10;

--     report_id    | product_type | count 
-- -----------------+--------------+-------
--  179852          | CONCOMITANT  |    43
--  117851          | CONCOMITANT  |    37
--  141218          | SUSPECT      |    36
--  174049          | SUSPECT      |    35
--  190041          | CONCOMITANT  |    34
--  2020-CFS-008964 | CONCOMITANT  |    31
--  190166          | SUSPECT      |    30
--  153719          | SUSPECT      |    28
--  104496          | SUSPECT      |    28
--  198546          | SUSPECT      |    28
-- (10 rows)


-- 4. check whether the combination of report_id and product is unique
SELECT report_id, product, COUNT(*) AS count
FROM staging_caers_event_product
GROUP BY report_id, product
ORDER BY count DESC
LIMIT 10;

--     report_id    |   product   | count 
-- -----------------+-------------+-------
--  2020-CFS-012660 | EXEMPTION 4 |    25
--  2021-CFS-006581 | EXEMPTION 4 |    21
--  2020-CFS-011663 | EXEMPTION 4 |    18
--  2018-CFS-011601 | EXEMPTION 4 |    16
--  2019-CFS-009256 | EXEMPTION 4 |    16
--  2020-CFS-008548 | EXEMPTION 4 |    13
--  2023-CFS-003427 | EXEMPTION 4 |    13
--  209212          | EXEMPTION 4 |    13
--  2018-CFS-002078 | EXEMPTION 4 |    13
--  2021-CFS-000121 | EXEMPTION 4 |    12
-- (10 rows)
