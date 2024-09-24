# Project and region configuration
variable "project_id" {
  description = "The project ID where resources will be created"
  type        = string
  default     = "qwiklabs-gcp-02-e6dd77716ac2"
}

# VPC and Subnet configurations
variable "vpc_network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "vpc-network-y52q"
}

# Subnet variables
variable "subnet_1_name" {
  type        = string
  default     = "subnet-a-h5pn"
}

variable "subnet_1_ip_range" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.10.10.0/24"
}

variable "subnet_1_region" {
  type        = string
  default     = "us-east1"
}


variable "subnet_2_name" {
  type        = string
  default     = "subnet-b-jz9i"
}

variable "subnet_2_ip_range" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.10.20.0/24"
}

variable "subnet_2_region" {
  type        = string
  default     = "us-east4"
}



variable "firewall_rule_1_name" {
  type        = string
  default     = "svbc-firewall-ssh"
}

variable "firewall_rule_2_name" {
  type        = string
  default     = "cwmy-firewall-rdp"
}

variable "firewall_rule_3_name" {
  type        = string
  default     = "bgct-firewall-icmp"
}



# VM Instance
variable "instance_1_name" {
  description = "The name of the first VM instance"
  type        = string
  default     = "us-test-01"
}

variable "instance_2_name" {
  description = "The name of the second VM instance"
  type        = string
  default     = "us-test-02"
}


variable "instance_1_subnet_name" {
  type        = string
  default     = "subnet-a-h5pn"
}

variable "instance_2_subnet_name" {
  type        = string
  default     = "subnet-b-jz9i"
}


variable "instance_1_zone" {
  type        = string
  default     = "us-east1-c"
}

variable "instance_2_zone" {
  type        = string
  default     = "us-east4-b"
}