=CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product TEXT NOT NULL,
  product_code INTEGER,
  description TEXT
);

CREATE TABLE reports (
  report_id TEXT PRIMARY KEY,
  date_event DATE,
  date_fda_first_received_case DATE,
  patient_age INTEGER,
  age_units TEXT,
  sex TEXT
);

CREATE TABLE report_products (
  report_id TEXT REFERENCES reports(report_id),
  product_id INTEGER REFERENCES products(product_id),
  product_type TEXT,
  PRIMARY KEY (report_id, product_id)
);

CREATE TABLE outcomes (
  outcome_id SERIAL PRIMARY KEY,
  outcome_description TEXT
);

CREATE TABLE report_outcomes (
  report_id TEXT REFERENCES reports(report_id),
  outcome_id INTEGER REFERENCES outcomes(outcome_id),
  PRIMARY KEY (report_id, outcome_id)
);

CREATE TABLE symptoms (
  meddra_term_id SERIAL PRIMARY KEY,
  term TEXT
);

CREATE TABLE report_symptoms (
  report_id TEXT REFERENCES reports(report_id),
  meddra_term_id INTEGER REFERENCES symptoms(meddra_term_id),
  PRIMARY KEY (report_id, meddra_term_id)
);
