HTTPS Content-Based Load Balancer with Terraform

https://www.cloudskillsboost.google/games/5416/labs/35111

GSP206

# Code
```
git clone https://github.com/GoogleCloudPlatform/terraform-google-lb-http.git
cd ~/terraform-google-lb-http/examples/multi-backend-multi-mig-bucket-https-lb
```

In the examples/multi-backend-multi-mig-bucket-https-lb/variables.tf file, update the region definitions to the following:
```
group1_region = us-central1
group2_region = us-east1
group3_region = europe-west4
```

## Run Terraform
```
terraform init
terraform plan -out=tfplan -var 'project=qwiklabs-gcp-02-d47123b81440'
terraform apply tfplan
```

## Run the following to get the external URL:
```
EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)
echo https://${EXTERNAL_IP}
```


## Now append the URL with group1, group2 and group3.
Your final URLs should look like (make sure to replace EXTERNAL_IP with your load balancer IP):
```
https://EXTERNAL_IP/group1
```

Example
```
https://34.144.228.163/group1/
https://34.144.228.163/group2/
https://34.144.228.163/group3/
```