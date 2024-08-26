GSP233

https://www.cloudskillsboost.google/games/5407/labs/35068


# Commands

```
gsutil -m cp -r gs://spls/gsp233/* .
cd tf-gke-k8s-service-lb
```


```
terraform init
terraform apply -var="region=us-east1" -var="location=us-east1-c"
```


# Output
Verify resources created by Terraform
In the console, navigate to Navigation menu > Kubernetes Engine.
Click on tf-gke-k8s cluster and check its configuration.
In the left panel, click Gateways, Services & Ingress and check the nginx service status.
Click the Endpoints IP address to open the Welcome to nginx! page in a new browser tab.


In this lab, you used Terraform to initialize, plan, and deploy a Kubernetes cluster along with a service.

