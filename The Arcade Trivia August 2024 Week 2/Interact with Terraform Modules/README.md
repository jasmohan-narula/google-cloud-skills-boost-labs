# Interact with Terraform Modules

https://www.cloudskillsboost.google/games/5396/labs/35021

GSP751

Terraform Network module GCP
https://registry.terraform.io/modules/terraform-google-modules/network/google/3.3.0

Terraform Network module GCP Inputs
https://registry.terraform.io/modules/terraform-google-modules/network/google/3.3.0?tab=inputs

https://github.com/github/gitignore/blob/main/Terraform.gitignore






# Start
```
git clone https://github.com/terraform-google-modules/terraform-google-network
cd terraform-google-network
git checkout tags/v6.0.1 -b v6.0.1
```


```
gcloud config list --format 'value(core.project)'
```


# Provision infrastructure
In Cloud Shell, navigate to your simple_project directory:
```
cd ~/terraform-google-network/examples/simple_project
```

Initialize your Terraform configuration:
```
terraform init
```

Create your VPC:
```
terraform apply
```
To apply the changes and continue, respond to the prompt with yes.

# Clean up your infrastructure
Destroy the infrastructure you created:
```
terraform destroy
```
Respond to the prompt with yes. Terraform will destroy the infrastructure you created.


# Custom Project
In Cloud Shell, navigate to your simple_project directory:
```
cd ~/custom_project/simple_project
```

Initialize your Terraform configuration:
```
terraform init
```

Create your VPC:
```
terraform apply
```

## Upload files to the bucket
```
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/index.html > index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/blob/master/modules/aws-s3-static-website-bucket/www/error.html > error.html
```

Example bucket
```
gsutil cp *.html gs://YOUR-BUCKET-NAME
gsutil cp *.html gs://2024-terraform-test-qwiklabs-gcp-04-783739d7c3de
```


## Access static website with link
https://storage.cloud.google.com/YOUR-BUCKET-NAME/index.html

https://storage.cloud.google.com/2024-terraform-test-qwiklabs-gcp-04-783739d7c3de/index.html

