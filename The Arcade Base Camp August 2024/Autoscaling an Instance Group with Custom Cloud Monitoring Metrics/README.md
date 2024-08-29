# Autoscaling an Instance Group with Custom Cloud Monitoring Metrics

https://www.cloudskillsboost.google/games/5383/labs/34947

GSP087



## Task 2. Create a bucket

In the Cloud Console, from the Navigation menu select Cloud Storage > Buckets, then click Create.

- Bucket name: 20240829-compute-autoscaling

Accept the default values then click Create.

Click Confirm for Public access will be prevented pop-up if prompted.

Next, run the following command in Cloud Shell to copy the startup script files from the lab default Cloud Storage bucket to your Cloud Storage bucket.
```
gsutil cp -r gs://spls/gsp087/* gs://20240829-compute-autoscaling
```


## Task 3. Creating an instance template

In the Metadata section of the Management tab, enter these metadata keys and values, clicking the + Add item button to add each one. Remember to substitute your bucket name for the [YOUR_BUCKET_NAME] placeholder:

Key Value
- startup-script-url  gs://20240829-compute-autoscaling/startup.sh
- gcs-bucket  gs://20240829-compute-autoscaling


```
gcloud compute instance-templates create autoscaling-instance01 --project=qwiklabs-gcp-00-6f06caef3a6d --machine-type=e2-medium --network-interface=network=default,network-tier=PREMIUM,stack-type=IPV4_ONLY --metadata=startup-script-url=gs://20240829-compute-autoscaling/startup.sh,gcs-bucket=gs://20240829-compute-autoscaling,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=829834577382-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=autoscaling-instance01,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240815,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```


## Task 4. Creating the instance group
```
gcloud beta compute instance-groups managed create autoscaling-instance-group-1 \
    --project=qwiklabs-gcp-00-6f06caef3a6d \
    --base-instance-name=autoscaling-instance-group-1 \
    --template=projects/qwiklabs-gcp-00-6f06caef3a6d/global/instanceTemplates/autoscaling-instance01 \
    --size=1 \
    --zone=us-central1-f \
    --default-action-on-vm-failure=repair \
    --no-force-update-on-repair \
    --standby-policy-mode=manual \
    --list-managed-instances-results=pageless \
&& \
gcloud beta compute instance-groups managed set-autoscaling autoscaling-instance-group-1 \
    --project=qwiklabs-gcp-00-6f06caef3a6d \
    --zone=us-central1-f \
    --mode=off \
    --min-num-replicas=1 \
    --max-num-replicas=10 \
    --target-cpu-utilization=0.6 \
    --cool-down-period=60
```


## Task 6. Verifying that the Node.js script is running

Still in the Compute Engine Instance groups window, click the name of the autoscaling-instance-group-1 to display the instances that are running in the group.

Scroll down and click the instance name. Because autoscaling has not started additional instances, there is just a single instance running.

In the Details tab, in the Logs section, click the Logging link to view the logs for the VM instance.

Wait a minute or 2 to let some data accumulate. Enable the Show query toggle, you will see resource.type and resource.labels.instance_id in the Query preview box.

Add "nodeapp" as line 3, so the code looks similar to this:
```
resource.type="gce_instance"
resource.labels.instance_id="6155937625854034708"
nodeapp
```

Click Run query.


### Output
{
  "insertId": "12km8bwf7c9djq",
  "jsonPayload": {
    "message": "startup-script-url: nodeapp: available",
    "localTimestamp": "2024-08-29T13:59:12.4795Z",
    "omitempty": null
  },
  "resource": {
    "type": "gce_instance",
    "labels": {
      "instance_id": "6155937625854034708",
      "zone": "us-central1-f",
      "project_id": "qwiklabs-gcp-00-6f06caef3a6d"
    }
  },
  "timestamp": "2024-08-29T13:59:12.479721454Z",
  "severity": "INFO",
  "labels": {
    "instance_name": "autoscaling-instance-group-1-zq3x"
  },
  "logName": "projects/qwiklabs-gcp-00-6f06caef3a6d/logs/google_metadata_script_runner",
  "sourceLocation": {
    "file": "main.go",
    "line": "283",
    "function": "main.setupAndRunScript"
  },
  "receiveTimestamp": "2024-08-29T13:59:12.648859218Z"
}


## Task 7. Configure autoscaling for the instance groups

In the Cloud Console, go to Compute Engine > Instance groups.

Click the autoscaling-instance-group-1 group.

Click Edit.

Under Autoscaling set Autoscaling mode to On: add and remove instances to the group.

Set Minimum number of instances: 1 and Maximum number of instances: 3

Under Autoscaling signals click ADD SIGNAL to edit metric. Set the following fields, leave all others at the default value.

- Signal type: Cloud Monitoring metric new. Click Configure.
- Under Resource and metric click SELECT A METRIC and navigate to VM Instance > Custom metrics > Custom/appdemo_queue_depth_01.
- Click Apply.

- Utilization target: 150
When custom monitoring metric values are higher or lower than the Target value, the autoscaler scales the managed instance group, increasing or decreasing the number of instances. The target value can be any double value, but for this lab, the value 150 was chosen because it matches the values being reported by the custom monitoring metric.

- Utilization target type: Gauge. Click Select.
The Gauge setting specifies that the autoscaler should compute the average value of the data collected over the last few minutes and compare it to the target value. (By contrast, setting Target mode to DELTA_PER_MINUTE or DELTA_PER_SECOND autoscales based on the observed rate of change rather than an average value.)

Click Save.
