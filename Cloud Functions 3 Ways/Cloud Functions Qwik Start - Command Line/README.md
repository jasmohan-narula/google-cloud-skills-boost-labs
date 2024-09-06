# Cloud Functions: Qwik Start - Command Line

https://www.cloudskillsboost.google/course_templates/696/labs/461617

GSP080

## Task 1. Create a function

```
gcloud config set run/region europe-west1
mkdir gcf_hello_world && cd $_
```

Create and open index.js to edit:
```
nano index.js
```

Create and open package.json to edit:
```
nano package.json
```

```
npm install
```


## Task 2. Deploy your function

Deploy the helloPubSub function to a pub/sub topic named cf-demo
```
gcloud functions deploy nodejs-pubsub-function \
  --gen2 \
  --runtime=nodejs20 \
  --region=europe-west1 \
  --source=. \
  --entry-point=helloPubSub \
  --trigger-topic cf-demo \
  --stage-bucket qwiklabs-gcp-00-da788ae30048-bucket \
  --service-account cloudfunctionsa@qwiklabs-gcp-00-da788ae30048.iam.gserviceaccount.com \
  --allow-unauthenticated
```

Verify the status of the function:
```
gcloud functions describe nodejs-pubsub-function \
  --region=europe-west1 
```

## Task 3. Test the function
```
gcloud pubsub topics publish cf-demo --message="Cloud Function Gen2"
```

## Task 4. View logs
```
gcloud functions logs read nodejs-pubsub-function \
  --region=europe-west1 
```

## Task 5. Test your understanding QUIZ
Serverless lets you write and deploy code without the hassle of managing the underlying infrastructure.
- True