# Get Started with Dataplex: Challenge Lab

ARC117

https://www.cloudskillsboost.google/course_templates/726/labs/461571


## Setup
```
export PROJECT_ID=$(gcloud config get-value project)

export REGION=europe-west1
gcloud config set compute/region $REGION

gcloud services enable dataplex.googleapis.com datacatalog.googleapis.com
```


## Task 1. Create a lake with a raw zone
Create a lake named **Customer Engagements** using the **europe-west1** region, with a regional raw zone named **Raw Event Data**.

```
gcloud dataplex lakes create customer-engagements \
   --location=$REGION \
   --display-name="Customer Engagements" \
   --description="Customer Engagements"

gcloud dataplex zones create raw-event-data \
   --lake=customer-engagements \
   --location=$REGION \
   --resource-location-type=SINGLE_REGION \
   --type=RAW \
   --display-name="Raw Event Data" \
   --description="Raw Event Data" \
   --discovery-enabled \
   --discovery-schedule="0 * * * *"
```


## Task 2. Create and attach a Cloud Storage bucket to the zone

Create a Cloud Storage bucket named **qwiklabs-gcp-02-058408a6a615** in the **europe-west1** region, and attach it as a regional asset named **Raw Event Files** to the **Raw Event Data** zone.


```
gsutil mb -l $REGION gs://$PROJECT_ID/

gcloud dataplex assets create raw-event-files \
   --lake=customer-engagements \
   --zone=raw-event-data \
   --location=$REGION \
   --resource-type=STORAGE_BUCKET \
   --resource-name=projects/my-project/buckets/$PROJECT_ID
   --discovery-enabled \
   --display-name="Raw Event Files"
```




## Task 3. Create and apply a tag template to a zone
Create a public tag template named **Protected Raw Data Template** with the location set to europe-west1, with an enumerated field named **Protected Raw Data Flag** that contains two values: **Y** and **N**.

Use this template to tag the zone named **Raw Event Data** as protected raw data.

- Note: The following command works in creating a tag template, but it set's the visibility as PRIVATE. As of 13-09-2024, there is no way to update it to PUBLIC via command line and it has to be edited in the Web UI.

- Reference - 
https://cloud.google.com/sdk/gcloud/reference/data-catalog/tag-templates/create

```
gcloud data-catalog tag-templates create protected_raw_data_template \
  --location=$REGION \
  --display-name="Protected Raw Data Template" \
  --field=id="protected_raw_data_flag",display-name="Protected Raw Data Flag",type='enum(Y|N)'
```

It's better to directly create the tag template from the WEB UI and then apply it to the zone.



## Clean-up (Optional)
```
gcloud dataplex assets delete raw-event-files --location=$REGION --zone=raw-event-data --lake=customer-engagements 

gcloud dataplex zones delete raw-event-data --location=$REGION --lake=customer-engagements

gcloud dataplex lakes delete customer-engagements --location=$REGION
```