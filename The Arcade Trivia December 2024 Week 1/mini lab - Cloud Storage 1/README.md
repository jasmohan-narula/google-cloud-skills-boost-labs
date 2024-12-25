# mini lab : Cloud Storage : 1

https://www.cloudskillsboost.google/games/5699/labs/36421

## Problem Statement

You have an existing Cloud Storage bucket named **BUCKET_NAME** that contains the following files necessary for a simple static website:

index.html (The main landing page)
error.html (Custom error page)
style.css
logo.jpg
Currently, the bucket is not configured for website hosting. Your task is to update the configuration to make this website publicly accessible.

As of now, there is no need to create a load balancer or CDN to redirect the request to the cloud storage bucket.


## Solution
```
export PROJECT=$(gcloud projects list --format="value(PROJECT_ID)")

gcloud storage buckets update gs://$PROJECT-bucket --no-uniform-bucket-level-access
gcloud storage buckets update gs://$PROJECT-bucket --web-main-page-suffix=index.html --web-error-page=error.html

gcloud storage objects update gs://$PROJECT-bucket/index.html --add-acl-grant=entity=AllUsers,role=READER
gcloud storage objects update gs://$PROJECT-bucket/error.html --add-acl-grant=entity=AllUsers,role=READER
```