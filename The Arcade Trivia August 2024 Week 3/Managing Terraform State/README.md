# Managing Terraform State
https://www.cloudskillsboost.google/games/5407/labs/35066

GSP752


# state-example

Terraform must store the state about your managed infrastructure and configuration. This state is used by Terraform to map real-world resources to your configuration, keep track of metadata, and improve performance for large infrastructures.

This state is stored by default in a local file named terraform.tfstate

A backend in Terraform determines how state is loaded and how an operation such as apply is executed. This abstraction enables non-local file state storage, remote execution, etc.

By default, Terraform uses the "local" backend.




```
cd state-example

touch main.tf
```

To retrieve your Project ID, run the following command:
```
gcloud config list --format 'value(core.project)'
```


```
terraform init
terraform apply
terraform show
```


Local Backend
- backend "local"

Add a Cloud Storage backend
- backend "gcs"



If you change backend
```
terraform init -migrate-state
```

If there are changes done remotely, then update state with:-
```
terraform refresh

terraform show
```


## You can now successfully destroy your infrastructure:
terraform destroy




# learn-terraform-import
Task 2. Import Terraform configuration

Warning: Importing infrastructure manipulates Terraform state in ways that could leave existing Terraform projects in an invalid state. Make a backup of your terraform.tfstate file and .terraform directory before using Terraform import on a real Terraform project, and store them securely.


```
docker run --name hashicorp-learn --detach --publish 8080:80 nginx:latest
docker ps
```


```
git clone https://github.com/hashicorp/learn-terraform-import.git
cd learn-terraform-import
terraform init
```



```
terraform import docker_container.web $(docker inspect -f {{.ID}} hashicorp-learn)
```

After running the above command, the following section in learn-terraform-import/docker.tf should get updated.
```
resource "docker_container" "web" {}
```


Verify
```
terraform show
```

## Create Config


```
terraform plan
```
Note: Terraform will show errors for the missing required arguments image and name. Terraform cannot generate a plan for a resource that is missing required arguments.


Copy your Terraform state into your docker.tf file:
```
terraform show -no-color > docker.tf
```
Note: The > symbol will replace the entire contents of docker.tf with the output of the terraform show command. 


```
terraform plan
terraform apply
```

## Create image resource

```
docker image inspect  -f {{.RepoTags}}

docker ps --filter "name=hashicorp-learn"
```