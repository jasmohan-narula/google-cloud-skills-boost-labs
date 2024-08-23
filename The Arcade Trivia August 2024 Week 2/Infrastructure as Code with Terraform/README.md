https://www.cloudskillsboost.google/games/5396/labs/35020


# Initialize
terraform init

# Apply changes
## Directly
terraform apply

## Plan to file and Apply
terraform plan -out static_ip
terraform apply "static_ip"

## Taint a specific resource so that it can be recreated
terraform taint google_compute_instance.vm_instance
terraform apply

# Check if instances are created
terraform show

# Destroy all changes made by Terraform
terraform destroy



# Notes
HCL - HashiCorp Configuration Language

Terraform scripts are written in HCL