# mini lab: BigQuery : 1

https://www.cloudskillsboost.google/games/5701/labs/36435


```
export BUCKET_NAME=qwiklabs-gcp-04-870146f1c1f8-44n4-bucket
export DATASET_NAME=work_day
export TABLE_NAME=employee

bq mk $DATASET_NAME

bq mk --table $DATASET_NAME.$TABLE_NAME employee_id:INTEGER,device_id:STRING,username:STRING,department:STRING,office:STRING

bq load --source_format=CSV --skip_leading_rows=1 $DATASET_NAME.$TABLE_NAME gs://$BUCKET_NAME/employees.csv employee_id:INTEGER,device_id:STRING,username:STRING,department:STRING,office:STRING
```
