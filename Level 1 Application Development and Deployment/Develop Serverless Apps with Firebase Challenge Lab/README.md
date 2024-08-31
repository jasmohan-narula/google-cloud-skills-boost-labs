# Develop Serverless Apps with Firebase: Challenge Lab

https://www.cloudskillsboost.google/games/5379/labs/34890

GSP344


## Provision the environment
```
gcloud config set project $(gcloud projects list --format='value(PROJECT_ID)' --filter='qwiklabs-gcp')

git clone https://github.com/rosera/pet-theory.git
```


## Task 1. Create a Firestore database
- Cloud Firestore	Native Mode
- Location	europe-west4


## Task 2. Populate the database
```
cd ~/pet-theory/lab06/firebase-import-csv/solution

npm install

node index.js netflix_titles_original.csv
```


## Task 3. Create a REST API

### Cloud Run development
- Container Registry Image	rest-api:0.1
- Cloud Run Service	netflix-dataset-service
- Permission	--allow-unauthenticated


```
PROJECT_ID=$(gcloud config get-value project)

gcloud builds submit --tag gcr.io/$PROJECT_ID/rest-api:0.1 .

gcloud run deploy netflix-dataset-service \
  --image gcr.io/$PROJECT_ID/rest-api:0.1 \
  --platform managed \
  --region europe-west4 \
  --allow-unauthenticated \
  --max-instances 1
```

### Verify
Go to Cloud Run and click netflix-dataset-service then copy the service URL:
- https://console.cloud.google.com/run?referrer=search&cloudshell=true&project=qwiklabs-gcp-02-a71c3885eb29

```
https://netflix-dataset-service-11349734807.europe-west4.run.app
```

```
export SERVICE_URL=https://netflix-dataset-service-11349734807.europe-west4.run.app
curl -X GET $SERVICE_URL
```
should respond with: {"status":"Netflix Dataset! Make a query."}


## Task 4. Firestore API access

### Deploy Cloud Run revision 0.2
- Container Registry Image	rest-api:0.2
- Cloud Run Service	netflix-dataset-service
- Permission	--allow-unauthenticated

```
cd ~/pet-theory/lab06/firebase-rest-api/solution-02

gcloud builds submit --tag gcr.io/$PROJECT_ID/rest-api:0.2 .

gcloud run deploy netflix-dataset-service \
  --image gcr.io/$PROJECT_ID/rest-api:0.2 \
  --platform managed \
  --region europe-west4 \
  --allow-unauthenticated \
  --max-instances 1
```


Go to Cloud Run and click netflix-dataset-service then copy the service URL:
```
export SERVICE_URL=https://netflix-dataset-service-11349734807.europe-west4.run.app
curl -X GET $SERVICE_URL/2019
```
should respond with json dataset



## Task 5. Deploy the Staging Frontend

### Deploy Frontend
- REST_API_SERVICE	REST API SERVICE URL
- Container Registry Image	frontend-staging:0.1
- Cloud Run Service	frontend-staging-service

```
cd ~/pet-theory/lab06/firebase-frontend
gcloud builds submit --tag gcr.io/$PROJECT_ID/frontend-staging:0.1 .

gcloud run deploy frontend-staging-service \
  --image gcr.io/$PROJECT_ID/frontend-staging:0.1 \
  --platform managed \
  --region europe-west4 \
  --allow-unauthenticated \
  --max-instances 1 \
  --set-env-vars "REST_API_SERVICE=$SERVICE_URL"
```

### Verify
https://console.cloud.google.com/run/detail/europe-west4/frontend-staging-service/metrics?cloudshell=true&project=qwiklabs-gcp-02-a71c3885eb29

```
https://frontend-staging-service-11349734807.europe-west4.run.app
```


## Task 6. Deploy the Production Frontend

### Deploy Frontend
- REST_API_SERVICE	REST API SERVICE URL
- Container Registry Image	frontend-production:0.1
- Cloud Run Service	frontend-production-service

```
cd ~/pet-theory/lab06/firebase-frontend/public
sed -i "s|const REST_API_SERVICE = \"data/netflix.json\"|const REST_API_SERVICE = \"$SERVICE_URL/2019\"|" app.js
```

```
cd ~/pet-theory/lab06/firebase-frontend

gcloud builds submit --tag gcr.io/$PROJECT_ID/frontend-production:0.1 .

gcloud run deploy frontend-production-service \
  --image gcr.io/$PROJECT_ID/frontend-production:0.1 \
  --platform managed \
  --region europe-west4 \
  --allow-unauthenticated \
  --max-instances 1 \
  --set-env-vars "REST_API_SERVICE=$SERVICE_URL"
```


### Verify
https://console.cloud.google.com/run/detail/europe-west4/frontend-production-service/metrics?cloudshell=true&project=qwiklabs-gcp-02-a71c3885eb29

```
https://frontend-production-service-11349734807.europe-west4.run.app
```