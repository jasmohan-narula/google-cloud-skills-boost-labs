# Project and region configuration
variable "project_id" {
  description = "The project ID where resources will be created"
  type        = string
  default     = "qwiklabs-gcp-02-2caed5be310f"
}

# VPC and Subnet configurations
variable "vpc_network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "taw-custom-network"
}

variable "default_region" {
  type        = string
  default     = "europe-west4"
}



# Subnet variables
variable "subnet_1_name" {
  type        = string
  default     = "subnet-europe-west4"
}

variable "subnet_1_range" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1_region" {
  type        = string
  default     = "europe-west4"
}


variable "subnet_2_name" {
  type        = string
  default     = "subnet-us-west1"
}

variable "subnet_2_range" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_2_region" {
  type        = string
  default     = "us-west1"
}




variable "subnet_3_name" {
  type        = string
  default     = "subnet-europe-west1"
}

variable "subnet_3_range" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.2.0.0/16"
}

variable "subnet_3_region" {
  type        = string
  default     = "europe-west1"
}