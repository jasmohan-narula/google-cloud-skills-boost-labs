# Configure Service Accounts and IAM for Google Cloud: Challenge Lab

https://www.cloudskillsboost.google/course_templates/702/labs/461623

ARC134


For this challenge lab, a virtual machine (VM) instance named lab-vm has been configured for you to complete tasks 2 to 6.

Create all the resources in us-central1 region and us-central1-c zone.

## Setup / Configurable
```
export PROJECT_ID=qwiklabs-gcp-02-714bc2e17ac3

export REGION=us-central1
export ZONE=us-central1-c
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
```

## Task 2. Create a service account using the gcloud CLI
```
export INSTANCE_NAME=lab-vm
gcloud compute ssh $INSTANCE_NAME
```

```
gcloud auth login
gcloud config set project $PROJECT_ID

gcloud iam service-accounts create devops --display-name devops
```

## Task 3. Grant IAM permissions to a service account using the gcloud CLI
```
SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA --role=roles/compute.instanceAdmin
```


## Task 4. Create a compute instance with a service account attached using gcloud
```
gcloud compute instances create vm-2 --zone $ZONE --machine-type=e2-standard-2 --service-account $SA --scopes "https://www.googleapis.com/auth/compute"

gcloud compute ssh vm-2 --zone $ZONE
```

```
gcloud compute instances list
exit
```

## Task 5. Create a custom role using a YAML file
```
echo "title: "Cloud SQL Connect"
description: "Connect access for Cloud SQL"
stage: "ALPHA"
includedPermissions:
- cloudsql.instances.connect
- cloudsql.instances.get" > role-definition.yaml

cat role-definition.yaml


gcloud iam roles create cloud_sql_connect --project $PROJECT_ID \
--file role-definition.yaml
```

## Task 6. Use the client libraries to access BigQuery from a service account
```
gcloud iam service-accounts create bigquery-qwiklab --display-name bigquery-qwiklab
SABQ=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=bigquery-qwiklab")
echo $SABQ

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SABQ --role=roles/bigquery.dataViewer
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SABQ --role=roles/bigquery.user

gcloud compute instances create bigquery-instance --zone $ZONE --machine-type=e2-standard-2 --service-account $SABQ --scopes "https://www.googleapis.com/auth/bigquery"
```

```
gcloud compute ssh bigquery-instance --zone $ZONE

#Change this with your echo for email address of BigQuery Service Account created in previous step
export SABQ=bigquery-qwiklab@qwiklabs-gcp-02-714bc2e17ac3.iam.gserviceaccount.com
export PROJECT_ID=qwiklabs-gcp-02-714bc2e17ac3

sudo apt-get update
sudo apt-get install -y git python3-pip

pip3 install --upgrade pip
pip3 install google-cloud-bigquery pyarrow pandas db-dtypes

echo "
from google.auth import compute_engine
from google.cloud import bigquery
credentials = compute_engine.Credentials(
    service_account_email='$SABQ')
query = '''
SELECT name, SUM(number) as total_people
FROM "bigquery-public-data.usa_names.usa_1910_2013"
WHERE state = 'TX'
GROUP BY name, state
ORDER BY total_people DESC
LIMIT 20
'''
client = bigquery.Client(
    project='$PROJECT_ID',
    credentials=credentials)
print(client.query(query).to_dataframe())
" > query.py

python3 query.py
```