# Cloud Functions: 3 Ways: Challenge Lab

https://www.cloudskillsboost.google/course_templates/696/labs/461619

ARC104

# Challenge scenario
You are just starting your junior cloud developer role. So far you have been helping teams create and manage Cloud Functions that respond to and get triggered by specific events in their Google Cloud projects.

You are expected to have the skills and knowledge for these tasks.

Your challenge
You are asked to help a newly formed development team with some of their initial work on a new project. Specifically, they need to automate running code based on specific activities in their Google Cloud project including HTTP requests and new events in Cloud Storage; you receive the following request to complete the following tasks:

Create a bucket to upload new project files.
Create, deploy, and test a Cloud Storage function (2nd gen) that logs new activities in the Cloud Storage bucket.
Create and deploy a function that responds to HTTP requests (2nd gen) with minimum instances to limit cold starts.
Some standards you should follow:

Ensure that any needed APIs (such as Cloud Functions) are successfully enabled.
Ensure that any needed IAM permissions (such as for the Cloud Storage service account) are assigned.
Create all resources in the **europe-west4** region, unless otherwise directed.
Each task is described in detail below, good luck!


## Task 1. Create a Cloud Storage bucket
Create a Cloud Storage bucket in **europe-west4** using your Project ID as the bucket name: **qwiklabs-gcp-02-351eba184db1**

```
export REGION="europe-west4"
gcloud config set compute/region $REGION

export BUCKET_NAME="qwiklabs-gcp-02-351eba184db1"

gsutil mb -l $REGION gs://$BUCKET_NAME

gsutil ls
```


## Task 2. Create, deploy, and test a Cloud Storage function (2nd gen)

1. Create and deploy a Cloud Function called cs-logger that executes every time a new event occurs in the bucket called qwiklabs-gcp-02-351eba184db1 you created in task 1. The function is written in Node.js 20.


2. Set the Region to europe-west4, and set the Entry point (Function to execute) to your function name.


3. Deploy the function with 2 maximum instances.

4. Use the following code blocks for the index.js and package.json:
- index.js (replace eventStorage with your function name):

5. Test the function by uploading any file to the bucket.

```
gcloud services enable cloudfunctions.googleapis.com cloudbuild.googleapis.com storage.googleapis.com run.googleapis.com eventarc.googleapis.com

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com


export PROJECT_ID=$(gcloud config get-value project)

PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher
```

```
export FUNCTION1_NAME="cs-logger"

mkdir $FUNCTION1_NAME && cd $FUNCTION1_NAME
touch index.js package.json

cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');
functions.cloudEvent('$FUNCTION1_NAME', (cloudevent) => {
  console.log('A new event in your Cloud Storage bucket has been logged!');
  console.log(cloudevent);
});
EOF

cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF

npm install


gcloud functions deploy $FUNCTION1_NAME \
  --gen2 \
  --runtime=nodejs20 \
  --entry-point=$FUNCTION1_NAME \
  --source . \
  --region=$REGION \
  --trigger-bucket=$BUCKET_NAME \
  --trigger-location $REGION \
  --min-instances=1 \
  --max-instances=2
```

```
echo "Hello World" > random.txt
gsutil cp random.txt $BUCKET/random.txt
```



## Task 3. Create and deploy a HTTP function (2nd gen) with minimum instances


Create and deploy a HTTP function (2nd gen) called **http-dispatcher** that responds to HTTP requests. The function is written in **Node.js 20**.

Set the Region to **europe-west4**, and set the Entry point (Function to execute) to your function name.

Deploy the function with **1 minimum instance** and **2 maximum instances**.

Use the following code blocks for the index.js and package.json:


```
export FUNCTION2_NAME="http-dispatcher"

cd ~
mkdir $FUNCTION2_NAME && cd $FUNCTION2_NAME
touch index.js package.json

cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');
functions.http('$FUNCTION2_NAME', (req, res) => {
  res.status(200).send('HTTP function (2nd gen) has been called!');
});
EOF

cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF


npm install


gcloud functions deploy $FUNCTION2_NAME \
  --gen2 \
  --region=$REGION \
  --runtime=nodejs20 \
  --trigger-http \
  --entry-point=$FUNCTION2_NAME \
  --min-instances=1 \
  --max-instances=2 \
  --allow-unauthenticated \
  --timeout 600s
```

```
gcloud functions describe $FUNCTION2_NAME --region=$REGION

export FUNCTION_URL=https://europe-west4-qwiklabs-gcp-02-351eba184db1.cloudfunctions.net/http-dispatcher
curl $FUNCTION_URL
```