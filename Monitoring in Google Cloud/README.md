# Monitoring in Google Cloud: Challenge Lab

https://www.cloudskillsboost.google/course_templates/747/labs/461647

ARC115


## Setup / Configurable
```
PROJECT_ID=qwiklabs-gcp-03-f64ed36f913f
REGION=us-west1
ZONE=us-west1-a

gcloud config set compute/zone "$ZONE"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "$REGION"
export REGION=$(gcloud config get compute/region)
```


## Task 1. Install the Cloud Logging and Monitoring agents
```
export EXTERNAL_IP=$(gcloud compute instances describe apache-vm --zone $ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
echo $EXTERNAL_IP
```

```
gcloud compute ssh --zone "$ZONE" "apache-vm" --project "$DEVSHELL_PROJECT_ID"
```

```
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh --also-install

curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh --also-install

sudo apt-get update
sudo apt-get install google-fluentd
sudo service google-fluentd start

sudo apt-get install stackdriver-agent
sudo service stackdriver-agent start


(cd /etc/stackdriver/collectd.d/ && sudo curl -O https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/collectd.d/apache.conf)
sudo service stackdriver-agent restart
```




## Task 2. Add an uptime check for Apache Web Server on the VM
For this task, you need to verify that your VM is up and running. To do this, create an uptime check with the resource type set to `instance`.

----
Go to Monitoring > Uptime Checks > +Create Uptime Check

| **Selection**       | Value             |
|-------------------|------------------|
| **Protocol**       | HTTP             |
| **Resource Type**  | Instance         |
| **Applies To**     | Single           |
| **Instance (Name)**| apache-vm        |

Click "Next"
Click "Next"

| **Selection**       | Value             |
|-------------------|------------------|
| **Title**       | apache-vm-uptime-check             |

Click "Test" then "CREATE"

```
gcloud monitoring uptime list-configs
```



## Task 3. Add an alert policy for Apache Web Server

Create an alert policy for Apache Web Server traffic that notifies you on your personal email account when the traffic rate exceeds `3 KiB/s`.

---

Navigation menu > Monitoring > Alerting > Edit notification channel

In `EMAIL` section, ADD the lab email
- student-02-0f1fd4e516e6@qwiklabs.net

---

Navigation menu > Monitoring > Alerting > Create Policy



**Select a metric**
- VM instance > Apache > Traffic
Click Apply

**Transform data section**
- Rolling window: 1 min
- Rolling window function: rate

**Configure alert trigger section**
- Alert trigger: Any time series violates
- Threshold position: Above threshold
- Threshold value: 4000

**Configure notifications and finalize alert section**
- Notification channels: Select the Display name you have created earlier
- Incident autoclose duration: 30 min
- Name the alert policy: vm-traffic-alert-policy

---

(Optional) Connect to the instance via SSH and run the following command to generate the traffic:
```
timeout 120 bash -c -- 'while true; do curl localhost | grep -oP ".*"; sleep .1s;done '
```


## Task 4. Create a dashboard and charts for Apache Web Server on the VM
For this task, you need to create a dashboard that's configured with charts.

Add the first line chart that has a `Resource` metric filter, `CPU load (1m)`, for the VM.

Add a second line chart that has a `Resource` metric filter, `Requests`, for `Apache` Web Server.

---

Navigation menu > Monitoring > Dashboards > Create dashboard > Add widget



## Task 5. Create a log-based metric
Next, create a log based metric that filters for the following values:
| **Filter**       | **Values**          |
|------------------|---------------------|
| Resource type    | VM                  |
| Logname          | apache-access       |
| Text Payload      | textPayload:"200"   |

---
---


Navigation menu > Log-based metrics > Create metric

| **Selection**                    | **Values**                    |
|----------------------------------|-------------------------------|
| Metric Type                      | Distribution                  |
| Log-based metric name            | logmetric                     |
| Field Name                       | textPayload                   |
| Regular Expression               | execution took (\d+)          |

**Build filter** -
```
resource.type="gce_instance"
log_name="projects/qwiklabs-gcp-03-f64ed36f913f/logs/apache-access"
textPayload:"200"
```