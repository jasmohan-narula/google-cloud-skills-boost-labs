# Create and Test a Document AI Processor

https://www.cloudskillsboost.google/games/5381/labs/34925

GSP924


## Task 1. Enable the Cloud Document AI API


## Task 2. Create and test a general form processor
### Create a processor
In the console, from the Navigation menu (Navigation menu icon), click Document AI > Overview.

Click Explore processors.

Click Create Processor for Form Parser, which is a type of general processor.

Specify the processor name as form-parser and select the region US (United States) from the list.

Click Create to create the general form-parser processor.

Make a note of the Processor ID as you will use it with curl to make a POST call to the API in a later task.

- Example: abc123456789


## Task 3. Set up the lab instance

### Connect to the lab VM instance using SSH
```
export PROCESSOR_ID=abc123456789
echo Your processor ID is:$PROCESSOR_ID
```

### Authenticate API requests
```
export PROJECT_ID=$(gcloud config get-value core/project)

export SA_NAME="document-ai-service-account"
gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member="serviceAccount:$SA_NAME@${PROJECT_ID}.iam.gserviceaccount.com" \
--role="roles/documentai.apiUser"

gcloud iam service-accounts keys create key.json \
--iam-account  $SA_NAME@${PROJECT_ID}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="$PWD/key.json"

echo $GOOGLE_APPLICATION_CREDENTIALS
```

### Download the sample form to the VM instance

```
gsutil cp gs://cloud-training/gsp924/health-intake-form.pdf .

echo '{"inlineDocument": {"mimeType": "application/pdf","content": "' > temp.json
base64 health-intake-form.pdf >> temp.json
echo '"}}' >> temp.json
cat temp.json | tr -d \\n > request.json
```


## Task 4. Make a synchronous process document request using curl

```
export LOCATION="us"
export PROJECT_ID=$(gcloud config get-value core/project)
curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
https://${LOCATION}-documentai.googleapis.com/v1beta3/projects/${PROJECT_ID}/locations/${LOCATION}/processors/${PROCESSOR_ID}:process > output.json
```

### Extract the form entities

```
sudo apt-get update 
sudo apt-get install jq
cat output.json | jq -r ".document.text"

cat output.json | jq -r ".document.pages[].formFields"
```

## Task 5. Test a Document AI form processor using the Python client libraries
### Configure your VM Instance to use the Document AI Python client
```
gsutil cp gs://cloud-training/gsp924/synchronous_doc_ai.py .

sudo apt install python3-pip
python3 -m pip install --upgrade google-cloud-documentai google-cloud-storage prettytable
```

## Task 6. Run the Document AI Python code
```
export PROJECT_ID=$(gcloud config get-value core/project)
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/key.json"

python3 synchronous_doc_ai.py \
--project_id=$PROJECT_ID \
--processor_id=$PROCESSOR_ID \
--location=us \
--file_name=health-intake-form.pdf | tee results.txt
```

### Output
You will see the following block of text output:
```
FakeDoc M.D. HEALTH INTAKE FORM Please fill out the questionnaire carefully. The information you provide will be used to complete your health profile and will be kept confidential. Date: Sally Walker Name: 9/14/19 ... 
```

```
Form data detected:

Page Number:1 Phone #: (906) 917-3486 (Confidence Scores: (Name) 1.0, (Value) 1.0) ... Date: 9/14/19 (Confidence Scores: (Name) 0.9999, (Value) 0.9999) ... Name: Sally Walker (Confidence Scores: (Name) 0.9973, (Value) 0.9973) ... 
```