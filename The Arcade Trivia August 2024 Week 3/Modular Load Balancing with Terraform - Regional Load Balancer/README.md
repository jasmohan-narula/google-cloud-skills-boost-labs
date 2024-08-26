GSP191

https://www.cloudskillsboost.google/games/5407/labs/35067

# Objectives
In this lab, you will learn how to:

Use load balancing modules for Terraform
- Create a regional TCP load balancer
- Create a regional internal TCP load balancer
- Create a global HTTP load balancer with Kubernetes Engine
- Create a global HTTPS content-based load balancer




# Commands

```
git clone https://github.com/GoogleCloudPlatform/terraform-google-lb
cd ~/terraform-google-lb/examples/basic

export GOOGLE_PROJECT=$(gcloud config get-value project)
export REGION=REGION
sed -i 's/us-central1/'"$REGION"'/g' variables.tf
```


```
terraform init
terraform apply
```


# Output
```
EXTERNAL_IP=$(terraform output | grep load_balancer_default_ip | cut -d = -f2 | xargs echo -n)
echo "http://${EXTERNAL_IP}"
```

Click on the http://${EXTERNAL_IP} address in the output to open the link to the load balancer.
