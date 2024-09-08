terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.0.0"
    }
  }

  // Uncomment this part after the bucket is created, and run "terraform init" again. Say YES to copy exisiting state file.
  /* */
  backend "gcs" {
    bucket = "tf-bucket-899112"
    prefix = "terraform/state"
  }
  /* */
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "instances" {
  source     = "./modules/instances"
}

module "storage" {
  source = "./modules/storage"
}


module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "6.0.0"

    project_id   = var.project_id
    network_name = var.vpc_network_name
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = var.region
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = var.region
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        }
    ]
}


resource "google_compute_firewall" "tf_firewall" {
  name    = "tf-firewall"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}