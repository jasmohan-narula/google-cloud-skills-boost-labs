# Assessing Data Quality with Dataplex

GSP1158

https://www.cloudskillsboost.google/course_templates/681/labs/466055


## Enable "Cloud Dataproc API"


## Task 1. Create a lake, zone, and asset in Dataplex

## Task 2. Query a BigQuery table to review data quality
```
SELECT * FROM `qwiklabs-gcp-00-4b445ea9380e.customers.contact_info`
ORDER BY id
LIMIT 50
```

## Task 3. Create and upload a data quality specification file
```
nano dq-customer-raw-data.yaml

gsutil cp dq-customer-raw-data.yaml gs://qwiklabs-gcp-00-4b445ea9380e-bucket
```


## Task 4. Define and run a data quality job in Dataplex


## Task 5. Review data quality results in BigQuery
```
WITH
zero_record AS (
    SELECT
        'VALID_EMAIL_ID' AS rule_binding_id,
),
data AS (
    SELECT
      *,
      'VALID_EMAIL_ID' AS rule_binding_id,
    FROM
      `qwiklabs-gcp-00-4b445ea9380e.customers.contact_info` d
    WHERE
      True
),
last_mod AS (
    SELECT
        project_id || '.' || dataset_id || '.' || table_id AS _internal_table_id,
        TIMESTAMP_MILLIS(last_modified_time) AS last_modified
    FROM `qwiklabs-gcp-00-4b445ea9380e.customers.__TABLES__`
),
validation_results AS (SELECT
    'VALID_EMAIL_ID' AS rule_binding_id,
    'VALID_EMAIL' AS _internal_rule_id,
    'qwiklabs-gcp-00-4b445ea9380e.customers.contact_info' AS _internal_table_id,
    'email' AS _internal_column_id,
    data.email AS _internal_column_value,
    
    'CONFORMANCE' AS _internal_dimension,

    CASE

      WHEN email IS NULL THEN CAST(NULL AS BOOLEAN)
      WHEN REGEXP_CONTAINS( CAST( email  AS STRING), '^[^@]+[@]{1}[^@]+$' ) THEN TRUE

    ELSE
      FALSE
    END AS _internal_simple_rule_row_is_valid,

    FALSE AS _internal_skip_null_count,

    CAST(NULL AS INT64) AS complex_rule_validation_errors_count,
    CAST(NULL AS BOOLEAN) AS _internal_complex_rule_validation_success_flag,
  FROM
    zero_record
  LEFT JOIN
    data
  ON
    zero_record.rule_binding_id = data.rule_binding_id
),
all_validation_results AS (
  SELECT
    'ff62b510-93ac-4def-ac6b-5a1dabaae82a' as _dq_validation_invocation_id,
    r.rule_binding_id AS _dq_validation_rule_binding_id,
    r._internal_rule_id AS _dq_validation_rule_id,
    r._internal_column_id AS _dq_validation_column_id,
    r._internal_column_value AS _dq_validation_column_value,
    CAST(r._internal_dimension AS STRING) AS _dq_validation_dimension,
    r._internal_simple_rule_row_is_valid AS _dq_validation_simple_rule_row_is_valid,
    r.complex_rule_validation_errors_count AS _dq_validation_complex_rule_validation_errors_count,
    r._internal_complex_rule_validation_success_flag AS _dq_validation_complex_rule_validation_success_flag,
    


  FROM
    validation_results r
)
SELECT
  *
FROM
  all_validation_results

WHERE
_dq_validation_simple_rule_row_is_valid is False
OR
_dq_validation_complex_rule_validation_success_flag is False
ORDER BY _dq_validation_rule_id
```


```
WITH
zero_record AS (
    SELECT
        'VALID_CUSTOMER' AS rule_binding_id,
),
data AS (
    SELECT
      *,
      'VALID_CUSTOMER' AS rule_binding_id,
    FROM
      `qwiklabs-gcp-00-4b445ea9380e.customers.contact_info` d
    WHERE
      True
),
last_mod AS (
    SELECT
        project_id || '.' || dataset_id || '.' || table_id AS _internal_table_id,
        TIMESTAMP_MILLIS(last_modified_time) AS last_modified
    FROM `qwiklabs-gcp-00-4b445ea9380e.customers.__TABLES__`
),
validation_results AS (SELECT
    'VALID_CUSTOMER' AS rule_binding_id,
    'NOT_NULL' AS _internal_rule_id,
    'qwiklabs-gcp-00-4b445ea9380e.customers.contact_info' AS _internal_table_id,
    'id' AS _internal_column_id,
    data.id AS _internal_column_value,
    
    'COMPLETENESS' AS _internal_dimension,

    CASE

      WHEN id IS NOT NULL THEN TRUE

    ELSE
      FALSE
    END AS _internal_simple_rule_row_is_valid,

    TRUE AS _internal_skip_null_count,

    CAST(NULL AS INT64) AS complex_rule_validation_errors_count,
    CAST(NULL AS BOOLEAN) AS _internal_complex_rule_validation_success_flag,
  FROM
    zero_record
  LEFT JOIN
    data
  ON
    zero_record.rule_binding_id = data.rule_binding_id
),
all_validation_results AS (
  SELECT
    'ff62b510-93ac-4def-ac6b-5a1dabaae82a' as _dq_validation_invocation_id,
    r.rule_binding_id AS _dq_validation_rule_binding_id,
    r._internal_rule_id AS _dq_validation_rule_id,
    r._internal_column_id AS _dq_validation_column_id,
    r._internal_column_value AS _dq_validation_column_value,
    CAST(r._internal_dimension AS STRING) AS _dq_validation_dimension,
    r._internal_simple_rule_row_is_valid AS _dq_validation_simple_rule_row_is_valid,
    r.complex_rule_validation_errors_count AS _dq_validation_complex_rule_validation_errors_count,
    r._internal_complex_rule_validation_success_flag AS _dq_validation_complex_rule_validation_success_flag,
    


  FROM
    validation_results r
)
SELECT
  *
FROM
  all_validation_results

WHERE
_dq_validation_simple_rule_row_is_valid is False
OR
_dq_validation_complex_rule_validation_success_flag is False
ORDER BY _dq_validation_rule_id
```