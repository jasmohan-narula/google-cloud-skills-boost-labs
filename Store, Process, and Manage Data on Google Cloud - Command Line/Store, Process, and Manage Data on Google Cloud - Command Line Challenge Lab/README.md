# Store, Process, and Manage Data on Google Cloud - Command Line: Challenge Lab

ARC102

https://www.cloudskillsboost.google/course_templates/659/labs/464091


## Challenge scenario
You are asked to help a newly formed development team with some of their initial work on a new project around storing and organizing photographs for wildlife organizations, called Wild. You have been asked to assist the Wild team with initial configuration for their application development environment; you receive the following request to complete the following tasks:

- Use commands to create a bucket for storing the photographs.
- Use commands to create a Pub/Sub topic that will be used by a Cloud Function you create.
- Use commands to create a Cloud Function.

Some standards you should follow:
- Create all resources in the us-east4 zone, unless otherwise directed.
- Use the project VPCs.
- Naming is normally team-resource, e.g. an instance could be named kraken-webserver1
- Allocate cost effective resource sizes. Projects are monitored and excessive resource use will result in the containing project's termination (and possibly yours), so beware. This is the guidance the monitoring team is willing to share; unless directed, use e2-micro for small Linux VMs and e2-medium for Windows or other applications such as Kubernetes nodes.



## Set Region
Create all resources in the us-west1 region, unless otherwise directed.

```
REGION=us-east4
gcloud config set compute/region $REGION
```

## Task 1. Create a bucket
Use commands (CLI/SDK) to create a bucket called wild-bucket-qwiklabs-gcp-01-b27332efd1e9 for the storage of the photographs.
```
export BUCKET_NAME='wild-bucket-qwiklabs-gcp-01-b27332efd1e9'
echo $BUCKET_NAME

gsutil mb -l $REGION gs://$BUCKET_NAME
```


## Task 2. Create a Pub/Sub topic
Use the command line to create a Pub/Sub topic called wild-topic-886 for the Cloud Function to send messages.

```
export TOPIC_NAME='wild-topic-886'
gcloud pubsub topics create $TOPIC_NAME
```


## Task 3. Create the thumbnail Cloud Function
Use the command line to create a Cloud Function called wild-thumbnail-creator that executes every time an object is created in the bucket wild-bucket-qwiklabs-gcp-01-b27332efd1e9 you created in task 1.

Make sure you set the Entry point (Function to execute) to thumbnail and Trigger to Cloud Storage.

In line 15 of index.js replace the text REPLACE_WITH_YOUR_TOPIC ID with the wild-topic-886 you created in task 2.


```
gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com


PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

PROJECT_ID=$(gcloud config get-value project)

BUCKET_SERVICE_ACCOUNT="${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role=roles/eventarc.eventReceiver

SERVICE_ACCOUNT="$(gsutil kms serviceaccount -p $DEVSHELL_PROJECT_ID)"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role='roles/pubsub.publisher'

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountTokenCreator

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$BUCKET_SERVICE_ACCOUNT \
  --role=roles/pubsub.publisher

```

```
export CLOUD_FUNCTION_NAME='wild-thumbnail-creator'

touch index.js package.json
```

Update the contents of file index.js and package.json

```
npm install

gcloud functions deploy $CLOUD_FUNCTION_NAME \
    --gen2 \
    --runtime=nodejs20 \
    --region=$REGION \
    --source=. \
    --entry-point=thumbnail \
    --trigger-resource=$BUCKET_NAME \
    --trigger-event=google.storage.object.finalize \
    --allow-unauthenticated

gcloud functions describe $CLOUD_FUNCTION_NAME \
  --region=$REGION 
```

### Verify

```
wget https://storage.googleapis.com/cloud-training/arc102/wildlife.jpg

gsutil cp wildlife.jpg gs://$BUCKET_NAME
```

Check in bucket. A file called wildlife.64x64_thumbnail.jpg will be created by the function.
