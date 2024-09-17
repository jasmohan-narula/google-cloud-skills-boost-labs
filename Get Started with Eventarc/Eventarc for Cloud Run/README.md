# Eventarc for Cloud Run

GSP773

https://www.cloudskillsboost.google/course_templates/727/labs/461590


## Task 1. Set up your environment
```
PROJECT_ID=$(gcloud config get-value project)
REGION=europe-west4

gcloud config set run/region $REGION

gcloud config set run/platform managed

gcloud config set eventarc/location $REGION
```

## Task 2. Enable service account
```
export PROJECT_NUMBER="$(gcloud projects list \
  --filter=$(gcloud config get-value project) \
  --format='value(PROJECT_NUMBER)')"

echo $PROJECT_NUMBER
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role='roles/eventarc.admin'
```

## Task 4. Create a Cloud Run sink
```
export SERVICE_NAME=event-display
export IMAGE_NAME="gcr.io/cloudrun/hello"

gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --allow-unauthenticated \
  --max-instances=3
```

- Service URL: https://event-display-510847985482.europe-west4.run.app


## Task 5. Create a Cloud Pub/Sub event trigger
```
gcloud eventarc triggers create trigger-pubsub \
  --destination-run-service=${SERVICE_NAME} \
  --event-filters="type=google.cloud.pubsub.topic.v1.messagePublished"

export TOPIC_ID=$(gcloud eventarc triggers describe trigger-pubsub \
  --format='value(transport.pubsub.topic)')

echo ${TOPIC_ID}

gcloud pubsub topics publish ${TOPIC_ID} --message="Hello there"
```

## Task 6. Create a Audit Logs event trigger

### Create Bucket
```
export BUCKET_NAME=$(gcloud config get-value project)-cr-bucket

gsutil mb -p $(gcloud config get-value project) \
  -l $(gcloud config get-value run/region) \
  gs://${BUCKET_NAME}/
```

### 2. Enable Audit Logs
Navigate to IAM & Admin > Audit Logs in the Google Cloud Console.

Check the box for Google Cloud Storage in the list of services.

Configure Log Types:

Click on the Permission types tab.
Select Admin Read, Admin Write, Data Read, and Data Write.
Click Save.


### Output in Logs Explorer
```
echo "Hello World" > random.txt
gsutil cp random.txt gs://${BUCKET_NAME}/random.txt
```

In the Cloud Console, go to Navigation menu > Logging > Logs Explorer. Enter the following query:-
```
resource.type="gcs_bucket"
resource.labels.bucket_name="qwiklabs-gcp-03-16ebcbcf2854-cr-bucket"
resource.labels.location="europe-west4"
```
Click on **Run Query** button.

### Create eventarc trigger for logging
Back in Cloud Console Terminal
```
gcloud eventarc triggers create trigger-auditlog \
  --destination-run-service=${SERVICE_NAME} \
  --event-filters="type=google.cloud.audit.log.v1.written" \
  --event-filters="serviceName=storage.googleapis.com" \
  --event-filters="methodName=storage.objects.create" \
  --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com


gsutil cp random.txt gs://${BUCKET_NAME}/random.txt
```

### Output in Cloud Run
Navigate to Navigation menu > Cloud Run to check the logs of the Cloud Run service, you should see the received event.




#

# Get Started with Eventarc: Challenge Lab

ARC118

https://www.cloudskillsboost.google/course_templates/727/labs/461591


## Task 1. Create a Pub/Sub topic
```
PROJECT_ID=$(gcloud config get-value project)
REGION=us-east1
gcloud config set run/region $REGION
```

```
export TOPIC_ID=$PROJECT_ID-topic

gcloud pubsub topics create $TOPIC_ID
gcloud pubsub subscriptions create ${PROJECT_ID}-topic-sub --topic=${PROJECT_ID}-topic
```


## Task 2. Create a Cloud Run sink
Create a Cloud Run sink with the following requirements:
Service name: pubsub-events
Image name: gcr.io/cloudrun/hello


```
export PROJECT_NUMBER="$(gcloud projects list \
  --filter=$(gcloud config get-value project) \
  --format='value(PROJECT_NUMBER)')"
echo $PROJECT_NUMBER

gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role='roles/eventarc.admin'
```

```
export SERVICE_NAME=pubsub-events
export IMAGE_NAME="gcr.io/cloudrun/hello"

gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --allow-unauthenticated \
  --max-instances=3
```



## Task 3. Create and test a Pub/Sub event trigger using Eventarc
Create a Pub/Sub event trigger named pubsub-events-trigger with the following requirements:
- Use the Cloud Run sink and Pub/Sub topic created in the previous tasks.
- To create the trigger on an existing Pub/Sub topic, add the following argument to the command used to create the trigger: --transport-topic=qwiklabs-gcp-00-4361ccd8af9d-topic

Test the Pub/Sub event trigger by publishing a message to the Pub/Sub topic.



```
echo $TOPIC_ID
echo $SERVICE_NAME

gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

gcloud eventarc triggers create pubsub-events-trigger \
  --destination-run-service=${SERVICE_NAME} \
  --destination-run-region=$REGION \
  --transport-topic=$TOPIC_ID \
  --event-filters="type=google.cloud.pubsub.topic.v1.messagePublished"
```

### Verify
```
gcloud pubsub topics publish ${TOPIC_ID} --message="Hello there"

gcloud logging read "resource.type=cloud_run_revision AND logName:('projects/${PROJECT_ID}/logs/run.googleapis.com%2Frequests')" --limit 50 --format "json"
```