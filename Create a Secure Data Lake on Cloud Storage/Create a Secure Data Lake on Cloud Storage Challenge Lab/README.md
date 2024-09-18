# Create a Secure Data Lake on Cloud Storage: Challenge Lab

ARC119

https://www.cloudskillsboost.google/course_templates/704/labs/461627

https://www.cloudskillsboost.google/games/5426/labs/35170


## Set Region and PROJECT ID
```
REGION=europe-west1
gcloud config set compute/region $REGION

ZONE=europe-west1-c
gcloud config set compute/zone $ZONE

PROJECT_ID=$(gcloud config get-value project)
```


## Ensure that any needed APIs (such as Dataplex API) are successfully enabled.
```
gcloud services enable storage.googleapis.com \
  dataplex.googleapis.com \
  cloudkms.googleapis.com \
  logging.googleapis.com

gcloud services enable dataplex.googleapis.com datacatalog.googleapis.com
```


## Task 1
### Create a BigQuery dataset
Sign into the project as User 2
```
bq --location=$REGION mk --dataset $PROJECT_ID:Raw_data

bq --location=$REGION load --source_format=AVRO \
    $PROJECT_ID:Raw_data.public-data \
    gs://spls/gsp1145/users.avro
```


## Task 2
### Add a zone to your lake

```
gcloud dataplex zones create temperature-raw-data \
    --lake=public-lake \
    --display-name="temperature raw data" \
    --type="RAW" \
    --resource-location-type=SINGLE_REGION \
    --location=$REGION \
    --project=$PROJECT_ID
```



## Task 3
### Attach an existing BigQuery Dataset to the Lake

Remain in the project as User 2:
```
gcloud services enable dataplex.googleapis.com

gcloud dataplex assets create customer-details-dataset \
    --zone=temperature-raw-data \
    --lake=public-lake \
    --display-name="Customer Details Dataset" \
    --resource-type=bigquery_dataset \
    --resource-name=projects/$PROJECT_ID/datasets/customer_reference_data \
    --discovery-enabled \
    --location=$REGION \
    --project=$PROJECT_ID
```



## Task 4: Create and Apply a Tag 

Use the WEB UI to complete the steps.

### 1. Create a Tag Template

To start tagging data, follow these steps to create a tag template:

1. **Create a Tag Template**:
   - **Template Display Name**: `Protected Data Template`
   - **Template ID**: Leave the default value.
   - **Location**: Use the default region.
   - **Visibility**: Public (recommended).

2. **Add a Field**:
   - Click **Add field** to create a new field in the tag template.
   - **Field Display Name**: `Protected Data Flag`
   - **Field ID**: Leave the default value.
   - **Type**: Enumerated
   - **Enumerated Values**:
     - **Values 1**: Enter `YES`.
     - Click **Add value**.
     - **Values 2**: Enter `NO`.

### 2. Apply the Tag Template

After creating the tag template, apply it to the specific columns in the BigQuery table you wish to label with a protected data status:

1. **Attach a Tag to a BigQuery Table**:
   - **Table**: `us-states`

2. **Choose What to Tag**:
   - Enable the checkboxes for the following columns:
     - `name`
     - `abbreviation`
     - `capital`

### 3. Search for Tagged Data Assets

After tagging data assets, you can search for them using Data Catalog within Dataplex:

1. Use the tag template `Protected Data Template` to find the tagged assets.
