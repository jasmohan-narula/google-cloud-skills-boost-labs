# Level 3: Google Cloud Functions
https://www.cloudskillsboost.google/games/5382


Open "Cloud Functions"
https://console.cloud.google.com/functions/list


Select '2nd Gen' option under Environment Section

Enter Name "cf-demo"

Select region

Enter trigger type as "HTTPS"

Set number of instances

Set runtime language

Deploy


### After deployment
Copy the URL


Open cloud console terminal and run the command
```
gcloud auth print-identity-token
```
Copy the authentication token


Then run this as a POST request
```
curl --location 'https://us-west1-qwiklabs-gcp-REPLACEME.cloudfunctions.net/cf-demo' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer ey_COPY_AUTHENTICATION_TOKEN_gg' \
--data '{
    "name": "Jasmohan"
}'
```