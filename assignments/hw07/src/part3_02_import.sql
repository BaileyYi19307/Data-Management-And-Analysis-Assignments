
copy staging_caers_event_product (
	date_fda_first_received_case, report_id, date_event,
	product_type, product, product_code,
	description, patient_age, age_units,
	sex, case_meddra_preferred_terms,
    case_outcome)
	-- use absolute path for copy
	-- /home/joe/projects/dma/classes
    from '/Users/baileyyi/hw7/homework07-BaileyYi19307/data/CAERS-Quarterly-20240731-CSV-PRODUCT-BASED.csv'
    (format csv, header, encoding 'LATIN1');