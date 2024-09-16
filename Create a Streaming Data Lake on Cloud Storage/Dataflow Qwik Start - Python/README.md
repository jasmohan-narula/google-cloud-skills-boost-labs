# Dataflow: Qwik Start - Python

https://www.cloudskillsboost.google/course_templates/705/labs/461629

GSP207


## Set Region
```
REGION=us-central1
gcloud config set compute/region $REGION
```

## Ensure that the Dataflow API is successfully enabled
```
gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com

gcloud services list --enabled
```

## Task 1. Create a Cloud Storage bucket
```
export PROJECT_ID=$(gcloud config get-value project)
gsutil mb -l us -b on gs://$PROJECT_ID-bucket
```

## Task 2. Install the Apache Beam SDK for Python
```
docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID python:3.9 /bin/bash

pip install 'apache-beam[gcp]'==2.42.0

python -m apache_beam.examples.wordcount --output OUTPUT_FILE

ls
```
- OUTPUT_FILE-00000-of-00001  bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

```
cat OUTPUT_FILE-00000-of-00001
```

## Task 3. Run an example Dataflow pipeline remotely
```
export PROJECT_ID=qwiklabs-gcp-02-a226de9a8630
export BUCKET=gs://$PROJECT_ID-bucket
echo $BUCKET

python -m apache_beam.examples.wordcount --project $DEVSHELL_PROJECT_ID \
  --runner DataflowRunner \
  --staging_location $BUCKET/staging \
  --temp_location $BUCKET/temp \
  --output $BUCKET/results/output \
  --region $REGION
```

In your output, wait until you see the message:

JOB_MESSAGE_DETAILED: Workers have started successfully.



## Task 4. Check that your Dataflow job succeeded
Open the Navigation menu and click Dataflow from the list of services.
You should see your wordcount job with a status of Running at first.

Click on the name to watch the process. When all the boxes are checked off, you can continue watching the logs in Cloud Shell.
The process is complete when the status is Succeeded.

Click Navigation menu > Cloud Storage in the Cloud Console.

Click on the name of your bucket. In your bucket, you should see the results and staging directories.

Click on the results folder and you should see the output files that your job created:

Click on a file to see the word counts it contains.

- https://storage.cloud.google.com/qwiklabs-gcp-02-a226de9a8630-bucket/results/output-00000-of-00001

- https://console.cloud.google.com/storage/browser/_details/qwiklabs-gcp-02-a226de9a8630-bucket/results/output-00000-of-00001;tab=live_object?project=qwiklabs-gcp-02-a226de9a8630