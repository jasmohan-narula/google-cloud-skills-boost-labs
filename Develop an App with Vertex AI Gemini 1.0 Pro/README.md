# Develop an App with Vertex AI Gemini 1.0 Pro

https://www.cloudskillsboost.google/focuses/86788

https://www.cloudskillsboost.google/games/5463/labs/35367



Task 1. Configure your environment and project



PROJECT_ID=$(gcloud config get-value project)
REGION=us-east1
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

gcloud services enable cloudbuild.googleapis.com cloudfunctions.googleapis.com run.googleapis.com logging.googleapis.com storage-component.googleapis.com aiplatform.googleapis.com


Task 2. Set up the application environment


gcloud auth list


mkdir ~/gemini-app
cd ~/gemini-app

Set up a Python virtual environment

python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate


pip install -r requirements.txt


Write the main app entry point

cat ~/gemini-app/app.py
cat ~/gemini-app/app_tab1.py
cat ~/gemini-app/response_utils.py



Task 4. Run and test the app locally
streamlit run app.py \
--browser.serverAddress=localhost \
--server.enableCORS=false \
--server.enableXsrfProtection=false \
--server.port 8080


Task 5. to 13
cat > ~/gemini-app/app_tab2.py
cat > ~/gemini-app/app_tab3.py
cat > ~/gemini-app/app_tab4.py


Task 14. Deploy the app to Cloud Run
cd ~/gemini-app

SERVICE_NAME='gemini-app-playground' # Name of your Cloud Run service.
AR_REPO='gemini-app-repo'            # Name of your repository in Artifact Registry that stores your application container image.
echo "SERVICE_NAME=${SERVICE_NAME}"
echo "AR_REPO=${AR_REPO}"

Create the Docker repository

gcloud artifacts repositories create "$AR_REPO" --location="$REGION" --repository-format=Docker
gcloud auth configure-docker "$REGION-docker.pkg.dev"

Build the container image
cat > ~/gemini-app/Dockerfile

gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME"

Deploy and test your app on Cloud Run
gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$PROJECT_ID \
  --set-env-vars=PROJECT_ID=$PROJECT_ID,REGION=$REGION