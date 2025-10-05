-- write your COPY statement to import a csv here
\copy squirrel_data(
    primary_fur_color,
    above_ground_sighter_measurement,
    date,
    longitude,
    latitude,
    above_or_below_ground
)
FROM 'squirrel_census.csv'
DELIMITER ','
CSV HEADER;
