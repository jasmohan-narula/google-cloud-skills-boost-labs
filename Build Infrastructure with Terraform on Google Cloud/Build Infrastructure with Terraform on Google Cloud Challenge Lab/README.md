# Build Infrastructure with Terraform on Google Cloud: Challenge Lab

GSP345

https://www.cloudskillsboost.google/course_templates/636/labs/464836




# Challenge scenario
You are a cloud engineer intern for a new startup. For your first project, your new boss has tasked you with creating infrastructure in a quick and efficient manner and generating a mechanism to keep track of it for future reference and changes. You have been directed to use Terraform to complete the project.

For this project, you will use Terraform to create, deploy, and keep track of infrastructure on the startup's preferred provider, Google Cloud. You will also need to import some mismanaged instances into your configuration and fix them.

In this lab, you will use Terraform to import and create multiple VM instances, a VPC network with two subnetworks, and a firewall rule for the VPC to allow connections between the two instances. You will also create a Cloud Storage bucket to host your remote backend.


## Things to customize
- Project id - qwiklabs-gcp-02-9b60a99a4591
- Bucket name - tf-bucket-899112
- Instance 3 to be created name - tf-instance-997522
- VPC network name - tf-vpc-455603
- region - us-central1
- zone - us-central1-c


## Task 1. Create the configuration files
In Cloud Shell, create your Terraform configuration files and a directory structure that resembles the following:
```
main.tf
variables.tf
modules/
└── instances
    ├── instances.tf
    ├── outputs.tf
    └── variables.tf
└── storage
    ├── storage.tf
    ├── outputs.tf
    └── variables.tf
```

```
mkdir -p modules/{instances,storage}
touch main.tf variables.tf
touch modules/instances/{instances.tf,outputs.tf,variables.tf}
touch modules/storage/{storage.tf,outputs.tf,variables.tf}
```

Copy the contents of the files from this github folder to GCP Console.


```
terraform init
```


### Import Exisiting instances into state file
Instance names - tf-instance-1, tf-instance-2

In the Google Cloud Console, on the Navigation menu, click Compute Engine > VM Instances. Two instances named tf-instance-1 and tf-instance-2 have already been created for you.

Copy their id's and replace in the following commands:-

```
terraform import module.instances.google_compute_instance.tf-instance-1 7198045662803405619
terraform import module.instances.google_compute_instance.tf-instance-2 3439784850275445555
```

```
terraform init
terraform apply
```


## Task 3. Configure a remote backend

First create the bucket

```
terraform init
terraform apply
```

Then uncomment the bucket parameters in main.tf file. Then migrate the state file to the bucket.

```
terraform init
terraform plan
```




# Task 4. Modify and update infrastructure

Navigate to the instances module and modify the **tf-instance-1** resource to use an **e2-standard-2** machine type.

Modify the **tf-instance-2** resource to use an **e2-standard-2** machine type.

Add a third instance resource and name it **tf-instance-997522**. For this third resource, use an **e2-standard-2** machine type. Make sure to change the machine type to **e2-standard-2** to all the three instances.

Initialize Terraform and apply your changes.


Uncomment the code for instance 3 in instances.tf
```
terraform init
terraform apply
```


# Task 5. Destroy resources
Comment out the code for instance 3 in instances.tf
```
terraform init
terraform apply
```



# Task 6. Use a module from the Registry
Uncomment the code out for the network to use the created vpc in instances.tf file

```
terraform init
terraform apply
```


# Task 7. Configure a firewall
```
terraform init
terraform apply
```