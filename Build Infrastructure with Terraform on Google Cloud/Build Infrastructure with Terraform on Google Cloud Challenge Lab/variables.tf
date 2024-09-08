variable "region" {
  description = "The region in which resources will be created"
  default     = "us-west1"
}

variable "zone" {
  description = "The zone in which resources will be created"
  default     = "us-west1-a"
}

variable "project_id" {
  description = "The Google Cloud project ID"
  default     = "qwiklabs-gcp-02-9b60a99a4591"  # Replace with your actual project ID
}

variable "instance3_name" {
  description = "Name of instance to be created"
  default     = "tf-instance-997522"
}

variable "bucket_name" {
  description = "Name of Bucket to be created"
  default     = "tf-bucket-899112"
}

variable "vpc_network_name" {
  description = "Name VPC network to be created"
  default     = "tf-vpc-455603"
}