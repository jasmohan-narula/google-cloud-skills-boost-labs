# Build a Data Mesh with Dataplex: Challenge Lab

GSP514

https://www.cloudskillsboost.google/course_templates/681/labs/466056


# Ensure that any needed APIs (such as Dataplex, Data Catalog, and Dataproc) are successfully enabled.

```
gcloud services enable \
    dataplex.googleapis.com \
    datacatalog.googleapis.com \
    dataproc.googleapis.com \
    storage.googleapis.com \
    bigquery.googleapis.com
```

# Create all resources in the us-east1 region, unless otherwise directed.
```
export REGION=us-east1
```

## Task 1. Create a Dataplex lake with two zones and two assets

The Cloud Storage bucket and BigQuery dataset for step 2 have been pre-created in this lab.

Create a Dataplex lake named `Sales Lake` with two regional zones:
- **Raw zone** named `Raw Customer Zone`
- **Curated zone** named `Curated Customer Zone`

Attach one pre-created asset to each zone:
- To the **Raw zone**, attach the Cloud Storage bucket named `qwiklabs-gcp-00-d4c6cf614736-customer-online-sessions` as a new asset named **Customer Engagements**.
- To the **Curated zone**, attach the BigQuery dataset named `qwiklabs-gcp-00-d4c6cf614736.customer_orders` as a new asset named **Customer Orders**.


### Create DATA Lake
```
export PROJECT_ID="qwiklabs-gcp-00-d4c6cf614736"
export LAKE_NAME="sales-lake"

gcloud config set project $PROJECT_ID

gcloud dataplex lakes create $LAKE_NAME \
    --project=$PROJECT_ID \
    --location=$REGION \
    --display-name="Sales Lake"
```

### Create Zones
```
export ZONE_NAME="raw-customer-zone"
gcloud dataplex zones create $ZONE_NAME \
    --lake=$LAKE_NAME \
    --project=$PROJECT_ID \
    --location=$REGION \
    --resource-location-type=SINGLE_REGION \
    --type=RAW \
    --display-name="Raw Customer Zone" \
    --discovery-enabled

export CURATED_ZONE_NAME="curated-customer-zone"
gcloud dataplex zones create $CURATED_ZONE_NAME \
    --lake=$LAKE_NAME \
    --project=$PROJECT_ID \
    --location=$REGION \
    --resource-location-type=SINGLE_REGION \
    --type="CURATED" \
    --display-name="Curated Customer Zone"
```

### Attach the Cloud Storage bucket to the Raw zone
```
export BUCKET_NAME_RAW=$PROJECT_ID-customer-online-sessions
echo $BUCKET_NAME_RAW


gcloud dataplex assets create customer-engagements \
    --project=$PROJECT_ID \
    --location=$REGION \
    --lake=$LAKE_NAME \
    --zone=$ZONE_NAME \
    --resource-type="STORAGE_BUCKET" \
    --resource-name="projects/$PROJECT_ID/buckets/$BUCKET_NAME_RAW" \
    --display-name="Customer Engagements"
```

### Attach BigQuery Dataset to zone
```
export BIGQUERY_DATASET_NAME_CURATED=customer_orders
echo $BIGQUERY_DATASET_NAME_CURATED

gcloud dataplex assets create customer-orders \
    --project=$PROJECT_ID \
    --location=$REGION \
    --lake=$LAKE_NAME \
    --zone=$CURATED_ZONE_NAME \
    --resource-type="BIGQUERY_DATASET" \
    --resource-name="projects/$PROJECT_ID/datasets/$BIGQUERY_DATASET_NAME_CURATED" \
    --display-name="Customer Orders"
```


## Task 2. Create and apply a tag template to a zone

Create a public tag template named `Protected Customer Data Template` with two enumerated fields:

- First field named `Raw Data Flag` with two values: `Yes` and `No`.
- Second field named `Protected Contact Information Flag` with two values: `Yes` and `No`.

Use this template to tag the `Raw Customer Zone` using a value of `Yes` for both flags.


---

Do it in UI

https://console.cloud.google.com/dataplex/templates/create?cloudshell=true&project=qwiklabs-gcp-00-d4c6cf614736


"Attach Tags" to Zone "Raw Customer Zone" object

https://console.cloud.google.com/dataplex/projects/qwiklabs-gcp-00-d4c6cf614736/locations/us-east1/entryGroups/@dataplex_20edf768e1210d0a6cfefdc23d23a42d/entries/a4fe1c0f136d4f029fa5d0538f042e8d?cloudshell=true&project=qwiklabs-gcp-00-d4c6cf614736



## Task 3. Assign a Dataplex IAM role to another user
Using the principle of least privilege, assign the appropriate Dataplex IAM role to User 2 (`student-01-ba2cb9a90f93@qwiklabs.net`) that allows them to upload new Cloud Storage files to the Dataplex asset named **Customer Engagements**.

---
Do it in UI

Dataplex > Manage Lakes > Secure

https://console.cloud.google.com/dataplex/secure?cloudshell=true&project=qwiklabs-gcp-00-d4c6cf614736

Double click 'Customer Engagements'

View by Principals > Grant Access
- Add principals - student-02-6d8f257811cf@qwiklabs.net
- Role - Dataplex Data Writere



## Task 4. Create and upload a data quality specification file to Cloud Storage
The Cloud Storage bucket for step 2 has been pre-created in this lab.

Create a data quality specification file named `dq-customer-orders.yaml` with the following specifications:

- `NOT NULL` rule applied to the `user_id` column of the `customer_orders.ordered_items` table.
- `NOT NULL` rule applied to the `order_id` column of the `customer_orders.ordered_items` table.

Upload the file to the Cloud Storage bucket named `qwiklabs-gcp-00-d4c6cf614736-dq-config`.


```
touch dq-customer-orders.yaml
vi dq-customer-orders.yaml
```

```
gsutil cp dq-customer-orders.yaml gs://$PROJECT_ID-dq-config/
```

## Task 5. Define and run a data quality job in Dataplex

The BigQuery dataset for step 1 has been pre-created in this lab.

Define a data quality job using the `dq-customer-orders.yaml` file with the following specifications:

| **Property**                     | **Value**                                                          |
|-----------------------------------|--------------------------------------------------------------------|
| **Data Quality Job Name**         | Customer Orders Data Quality Job                                   |
| **BigQuery destination table**    | `qwiklabs-gcp-00-d4c6cf614736.orders_dq_dataset.results`           |
| **User service account**          | Compute Engine default service account                             |

Run the data quality job immediately.

---

Do it in UI

Dataplex > Manage Lakes > Process > Data Quality

Click "CREATE TASK" button > "Check Data Quality [Legacy offering]" > "CREATE TASK"

https://console.cloud.google.com/dataplex/process/tasks?cloudshell=true&project=qwiklabs-gcp-00-d4c6cf614736&qTaskType=DATA_QUALITY


### Initial
Dataplex lake - sales-lake

Display Name - Customer Orders Data Quality Job

Id - customer-orders-data-quality-job

### Data quality specification

Select GCS file - qwiklabs-gcp-00-d4c6cf614736-dq-config/dq-customer-orders.yaml

Select BigQuery Dataset - qwiklabs-gcp-00-d4c6cf614736.orders_dq_dataset

BigQUery Table - results

Service account - Compute Engine default service account

Click "Continue"

### Schedule

Start - Immediately

Click "Create"