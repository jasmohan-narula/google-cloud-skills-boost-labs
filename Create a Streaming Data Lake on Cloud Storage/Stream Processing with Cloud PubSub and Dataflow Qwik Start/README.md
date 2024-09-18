# Stream Processing with Cloud Pub/Sub and Dataflow: Qwik Start
GSP903

https://www.cloudskillsboost.google/course_templates/705/labs/461630


## Set Region
```
REGION=europe-west1
gcloud config set compute/region $REGION
```

## Ensure that the Dataflow API is successfully enabled
```
gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com

gcloud services list --enabled
```


## Task 1. Create project resources
```
PROJECT_ID=$(gcloud config get-value project)
BUCKET_NAME="${PROJECT_ID}-bucket"
TOPIC_ID=my-id
REGION=europe-west1

AE_REGION=europe-west

gsutil mb gs://$BUCKET_NAME

gcloud pubsub topics create $TOPIC_ID


gcloud app create --region=$AE_REGION


gcloud scheduler jobs create pubsub publisher-job --schedule="* * * * *" \
    --topic=$TOPIC_ID --message-body="Hello!"
```
If prompted to enable the Cloud Scheduler API, press y and enter.

```
gcloud scheduler jobs run publisher-job
```




## Task 3. Start the pipeline - JAVA
```
git clone https://github.com/GoogleCloudPlatform/java-docs-samples.git
cd java-docs-samples/pubsub/streaming-analytics

mvn compile exec:java \
-Dexec.mainClass=com.examples.pubsub.streaming.PubSubToGcs \
-Dexec.cleanupDaemonThreads=false \
-Dexec.args=" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --inputTopic=projects/$PROJECT_ID/topics/$TOPIC_ID \
    --output=gs://$BUCKET_NAME/samples/output \
    --runner=DataflowRunner \
    --windowSize=2 \
    --tempLocation=gs://$BUCKET_NAME/temp"
```

## Task 4. Observe job and pipeline progress - OUTPUT
```
gsutil ls gs://${BUCKET_NAME}/samples/
```


## Task 5. Cleanup (Optional)
```
gcloud scheduler jobs delete publisher-job

gcloud pubsub topics delete $TOPIC_ID

gsutil -m rm -rf "gs://${BUCKET_NAME}/samples/output*"
gsutil -m rm -rf "gs://${BUCKET_NAME}/temp/*"

gsutil rb gs://${BUCKET_NAME}
```




#
# Create a Streaming Data Lake on Cloud Storage: Challenge Lab
ARC110

https://www.cloudskillsboost.google/course_templates/705/labs/461631

ARC119
https://www.cloudskillsboost.google/games/5426/labs/35170

This is similar to above task with variable name changes and Python code instead of JAVA

## Setup
```
PROJECT_ID=$(gcloud config get-value project)

BUCKET_NAME="${PROJECT_ID}-bucket"
TOPIC_ID=mytopic
REGION=us-central1
echo $PROJECT_ID $BUCKET_NAME $TOPIC_ID $REGION

gcloud config set compute/region $REGION
```

## Task 1 2 3
```
gcloud pubsub topics create $TOPIC_ID
gcloud app create --region=$REGION

gcloud scheduler jobs create pubsub publisher-job --schedule="* * * * *" \
    --topic=$TOPIC_ID --message-body="Hello Google!"
gcloud scheduler jobs run publisher-job

gsutil mb gs://$BUCKET_NAME
```

## Task 4. Run a Dataflow pipeline to stream data from a Pub/Sub topic to Cloud Storage - Python
```
docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID python:3.7 /bin/bash

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/pubsub/streaming-analytics
pip install -U -r requirements.txt  # Install Apache Beam dependencies

PROJECT_ID=qwiklabs-gcp-02-bb06457c2e34
BUCKET_NAME="${PROJECT_ID}-bucket"
TOPIC_ID=mytopic
REGION=us-central1
echo $PROJECT_ID $BUCKET_NAME $TOPIC_ID $REGION

python PubSubToGCS.py \
    --project=$PROJECT_ID \
    --region=$REGION \
    --input_topic=projects/$PROJECT_ID/topics/$TOPIC_ID \
    --output_path=gs://$BUCKET_NAME/samples/output \
    --runner=DataflowRunner \
    --window_size=2 \
    --num_shards=2 \
    --temp_location=gs://$BUCKET_NAME/temp
```

Verify
```
gsutil ls gs://${BUCKET_NAME}/samples/
```