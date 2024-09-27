# Monitor and Log with Google Cloud Observability: Challenge Lab

GSP338

https://www.cloudskillsboost.google/course_templates/749/labs/489775

- Create all resources in the `us-west1` region and `us-west1-c` zone, unless otherwise directed.


## Setup / Configurable
```
PROJECT_ID=qwiklabs-gcp-02-c8f195ff73cc
CUSTOM_METRIC_NAME=big_video_upload_rate
ALERT_THRESHOLD=4
REGION=us-west1
ZONE=us-west1-c

gcloud config set compute/zone "$ZONE"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "$REGION"
export REGION=$(gcloud config get compute/region)
```

## Task 1. Configure Cloud Monitoring
```
gcloud services enable monitoring.googleapis.com --project=$DEVSHELL_PROJECT_ID
```

### Extra command to login into the instance and delete the go binary, if it's corrupted
```
gcloud compute ssh --zone "$ZONE" "video-queue-monitor" --project "$DEVSHELL_PROJECT_ID"
```


## Task 2. Configure a Compute Instance to generate Custom Cloud Monitoring metrics
```
INSTANCE_ID=$(gcloud compute instances describe video-queue-monitor --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --format="get(id)")
echo $INSTANCE_ID

cat > video-queue-monitor-startup-script.sh <<EOF
#!/bin/bash
REGION="$REGION"
ZONE="$ZONE"
PROJECT_ID="$PROJECT_ID"

## Install Golang
sudo apt update && sudo apt -y
sudo apt-get install wget -y
sudo apt-get -y install git
sudo chmod 777 /usr/local/
sudo wget https://go.dev/dl/go1.19.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.6.linux-amd64.tar.gz
export PATH=\$PATH:/usr/local/go/bin

# Install ops agent 
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo service google-cloud-ops-agent start

# Create go working directory and add go path
mkdir /work
mkdir /work/go
mkdir /work/go/cache
export GOPATH=/work/go
export GOCACHE=/work/go/cache

# Install Video queue Go source code
cd /work/go
mkdir video
gsutil cp gs://spls/gsp338/video_queue/main.go /work/go/video/main.go

# Get Cloud Monitoring (stackdriver) modules
go get go.opencensus.io
go get contrib.go.opencensus.io/exporter/stackdriver

# Configure env vars for the Video Queue processing application
export MY_PROJECT_ID="$PROJECT_ID"
export MY_GCE_INSTANCE_ID=$INSTANCE_ID
export MY_GCE_INSTANCE_ZONE="$ZONE"

# Initialize and run the Go application
cd /work
go mod init go/video/main
go mod tidy
go run /work/go/video/main.go
EOF
```

```
gcloud compute instances remove-metadata video-queue-monitor --keys=startup-script --zone=$ZONE
gcloud compute instances add-metadata video-queue-monitor --metadata-from-file=startup-script=$(readlink -f video-queue-monitor-startup-script.sh) --zone=$ZONE

gcloud compute instances stop video-queue-monitor --zone=$ZONE
gcloud compute instances start video-queue-monitor --zone=$ZONE
```


## Task 3. Create a custom metric using Cloud Operations logging events


```
echo "DASHBOARD LINK"
echo "https://console.cloud.google.com/monitoring/dashboards?project=$DEVSHELL_PROJECT_ID&pageState=(\"dashboards\":(\"t\":\"Custom\"))"
```

```
gcloud logging metrics create $CUSTOM_METRIC_NAME \
    --description="Metric to monitor the rate at which high resolution video files, those recorded at either 4K or 8K resolution, are uploaded" \
    --log-filter='textPayload: "file_format: ([4,8]K).*"'
```

## Task 4. Add custom metrics to the Media Dashboard in Cloud Operations Monitoring

1. CLICK DASHBOARD LINK > MEDIA DASHBOARD
2. ADD WIDGET > LINE
3. SELECT METRIC > Fliter - CUSTOM > VM INSTANCE > CUSTOM METRICS > OpenCensus/{...} > APPLY
4. FILTER > INSTANCE ID = {AUTO_POPULATED_NUMBER} > APPLY
    - Example = 6688803180200557207

---
1. ADD WIDGET > LINE
2. SELECT METRIC > UNTICK ACTIVE
3. LOGGING > VM INSTANCE > LOG-BASED-METRIC > {CUSTOM_METRIC_NAME} > APPLY > APPLY
    - VM Instance > Logs-based metrics > logging/user/big_video_upload_rate


## Task 5. Create a Cloud Operations alert based on the rate of high resolution video file uploads

1. ALERTING FROM LEFT HAND MENU > CREATE POLICY
2. SELECT METRIC > UNTICK ACTIVE
3. LOGGING > VM INSTANCE > LOG-BASED-METRIC > <{YOUR_METRIC_NAME} > APPLY > NEXT
4. {THRESHOLD VALUE FROM LAB INSTRUCTIONS} > NEXT
    - 4
5. TOGGLE OFF NOTIFICATIONS CHANNEL > ALERTING POLICY NAME : ALERT_VIDEO_HIGH_RATE > CREATE POLICY
