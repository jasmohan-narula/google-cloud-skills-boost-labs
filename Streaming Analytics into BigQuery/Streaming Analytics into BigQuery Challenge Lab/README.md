# Streaming Analytics into BigQuery: Challenge Lab

ARC106

https://www.cloudskillsboost.google/course_templates/752/labs/461559


## Set Region
Create all resources in the us-west1 region, unless otherwise directed.

```
REGION=us-west1
gcloud config set compute/region $REGION
```

## Ensure that the Dataflow API is successfully enabled
```
gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com

gcloud services list --enabled
```


## Configuration
```
export BIGQUERY_DATASET_NAME=sensors_458
export BIGQUERY_TABLE_NAME=temperature_460
export PUB_SUB_TOPIC_NAME=sensors-temp-45209
export DATAFLOW_JOB_NAME=dfjob-95940

```



## Task 1. Create a Cloud Storage bucket
Create a Cloud Storage bucket using your Project ID as the bucket name: qwiklabs-gcp-00-5f6fd8a7410e
```
export PROJECT_ID=$(gcloud config get-value project)
echo $PROJECT_ID
gsutil mb -l us -b on gs://$PROJECT_ID
```


## Task 2. Create a BigQuery dataset and table
Create a BigQuery dataset called sensors_458 in the region named US (multi region).

In the created dataset, create a table called temperature_460 and add column data with STRING type.
```
bq --location=US mk --dataset $PROJECT_ID:$BIGQUERY_DATASET_NAME
bq mk --table $BIGQUERY_DATASET_NAME.$BIGQUERY_TABLE_NAME data:STRING
```


## Task 3. Set up a Pub/Sub topic
Create a Pub/Sub topic called sensors-temp-45209.

Use the default settings, which has enabled the checkbox for Add a default subscription.

```
gcloud pubsub topics create $PUB_SUB_TOPIC_NAME

gcloud pubsub subscriptions create $PUB_SUB_TOPIC_NAME-sub --topic=$PUB_SUB_TOPIC_NAME

gcloud pubsub subscriptions list
```




## Task 4. Run a Dataflow pipeline to stream data from Pub/Sub to BigQuery
Create and run a Dataflow job called dfjob-95940 to stream data from Pub/Sub topic to BigQuery, using the Pub/Sub topic and BigQuery table you created in the previous tasks.

Use the Custom Dataflow Template.

Use the below Path for the template file stored in Cloud Storage:
- gs://dataflow-templates-us-west1/latest/PubSub_to_BigQuery

Use the Pub/Sub topic that you created in a previous task: sensors-temp-45209

Use the Cloud Storage bucket that you created in a previous task as the temporary location: qwiklabs-gcp-00-5f6fd8a7410e

Use the BigQuery dataset and table that you created in a previous task as the output table: sensors_458.temperature_460

Use us-west1 as the regional endpoint.

```
gcloud dataflow jobs run $DATAFLOW_JOB_NAME \
    --gcs-location=gs://dataflow-templates-$REGION/latest/PubSub_to_BigQuery \
    --region=$REGION \
    --worker-machine-type e2-medium \
    --staging-location gs://$PROJECT_ID/temp \
    --parameters inputTopic=projects/$PROJECT_ID/topics/$PUB_SUB_TOPIC_NAME,outputTableSpec=$PROJECT_ID:$BIGQUERY_DATASET_NAME.$BIGQUERY_TABLE_NAME
```


## Task 5. Publish a test message to the topic and validate data in BigQuery

Publish a message to your topic using the following code syntax for Message: {"data": "73.4 F"}
Note: 73.4 F can be replaced with any value.

Run a SELECT statement in BigQuery to see the test message populated in your table.

```
gcloud pubsub topics publish $PUB_SUB_TOPIC_NAME \
    --message '{"data": "73.4 F"}'

bq query --use_legacy_sql=false \
    "SELECT * FROM \`$PROJECT_ID.$BIGQUERY_DATASET_NAME.$BIGQUERY_TABLE_NAME\`"
```

