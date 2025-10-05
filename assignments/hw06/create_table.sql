-- write your table creation sql here!

DROP TABLE IF EXISTS squirrel_data;
CREATE TABLE squirrel_data (
    id SERIAL PRIMARY KEY,
    primary_fur_color TEXT,
    above_ground_sighter_measurement INT,
    date DATE,
    longitude FLOAT,
    latitude FLOAT,
    above_or_below_ground TEXT
);
