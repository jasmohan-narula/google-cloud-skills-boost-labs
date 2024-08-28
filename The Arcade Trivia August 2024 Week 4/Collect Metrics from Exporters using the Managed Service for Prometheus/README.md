Collect Metrics from Exporters using the Managed Service for Prometheus

https://www.cloudskillsboost.google/games/5416/labs/35112

GSP1026

# Task 1. Deploy GKE cluster
```
gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone us-central1-f --enable-managed-prometheus
gcloud container clusters get-credentials gmp-cluster --zone=us-central1-f
```
*gmp-cluster* gets created in Kubernetes Engine


# Task 2. Set up a namespace
```
kubectl create ns gmp-test
```

# Task 3. Deploy the example application
The managed service provides a manifest for an example application that emits Prometheus metrics on its metrics port. The application uses three replicas.

```
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/example-app.yaml
```


# Task 4. Configure a PodMonitoring resource
The following manifest defines a PodMonitoring resource, prom-example, in the gmp-test namespace. The resource uses a Kubernetes label selector to find all pods in the namespace that have the label app with the value prom-example. The matching pods are scraped on a port named metrics, every 30 seconds, on the /metrics HTTP path.

```
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/pod-monitoring.yaml
```

Your managed collector is now scraping the matching pods.


# Task 5. Download the prometheus binary
```
git clone https://github.com/GoogleCloudPlatform/prometheus && cd prometheus
git checkout v2.28.1-gmp.4
wget https://storage.googleapis.com/kochasoft/gsp1026/prometheus
chmod a+x prometheus
```

# Task 6. Run the prometheus binary
```
export PROJECT_ID=$(gcloud config get-value project)
export ZONE=us-central1-f
./prometheus \
  --config.file=documentation/examples/prometheus.yml --export.label.project-id=$PROJECT_ID --export.label.location=$ZONE 
```

# Task 7. Download and run the node exporter
Open a new tab in cloud shell to run the node exporter commands.
```
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
cd node_exporter-1.3.1.linux-amd64
./node_exporter
```
You should see output like this indicating that the Node Exporter is now running and exposing metrics on port 9100:

## Create a config.yaml file
Stop the running prometheus binary in the 1st tab of Cloud Shell and have a new config file which will take the metrics from node exporter:

```
vi config.yaml
```
```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: node
    static_configs:
      - targets: ['localhost:9100']
```

Upload the config.yaml file you created to verify:
```
export PROJECT=$(gcloud config get-value project)
gsutil mb -p $PROJECT gs://$PROJECT
gsutil cp config.yaml gs://$PROJECT
gsutil -m acl set -R -a public-read gs://$PROJECT
```

Re-run prometheus pointing to the new configuration file by running the command below:
```
./prometheus --config.file=config.yaml --export.label.project-id=$PROJECT --export.label.location=$ZONE
```

# Output - UI
Use the following stat from the exporter to see its count in a PromQL query. In Cloud Shell, click on the web preview icon. Set the port to 9090 by selecting Change Preview Port and preview by clicking Change and Preview.

Write any query in the PromQL query Editor prefixed with “node_” this should bring up an input list of metrics you can select to visualize in the graphical editor.

- "node_cpu_seconds_total" provides graphical data.



