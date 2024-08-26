variable "project_id" {
  description = "The project ID to host the network in"
  default     = "qwiklabs-gcp-03-c4275109002a"
}

variable "project_region" {
  description = "Region of project"
  default     = "us-west1"
}

variable "project_zone" {
  description = "Zone of project"
  default     = "us-west1-a"
}

variable "bucket_name" {
  description = "Bucket name for project"
  default     = "2024-terraform-example-bucket"
}
