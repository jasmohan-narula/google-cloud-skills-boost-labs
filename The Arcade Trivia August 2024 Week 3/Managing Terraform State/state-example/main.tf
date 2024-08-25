provider "google" {
    # REPLACE WITH YOUR PROJECT ID
    project     = "qwiklabs-gcp-00-6fca66108860"
    region      = "us-west1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
    # REPLACE WITH YOUR PROJECT ID
  name        = "qwiklabs-gcp-00-6fca66108860"
  location    = "US"
  uniform_bucket_level_access = true

  force_destroy = true
}

terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}

/* terraform {
  backend "gcs" {
    # REPLACE WITH YOUR BUCKET NAME
    bucket  = "qwiklabs-gcp-00-6fca66108860"
    prefix  = "terraform/state"
  }
} */