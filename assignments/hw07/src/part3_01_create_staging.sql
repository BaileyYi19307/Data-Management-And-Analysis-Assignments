DROP TABLE IF EXISTS staging_caers_event_product;

CREATE TABLE staging_caers_event_product (
    id SERIAL PRIMARY KEY, 
    date_fda_first_received_case DATE,
    report_id TEXT,
    date_event DATE,
    product_type TEXT,
    product TEXT,
    product_code TEXT,
    description TEXT,
    patient_age NUMERIC,
    age_units varchar(255),
    sex varchar(255),
    case_meddra_preferred_terms TEXT,
    case_outcome TEXT
);
