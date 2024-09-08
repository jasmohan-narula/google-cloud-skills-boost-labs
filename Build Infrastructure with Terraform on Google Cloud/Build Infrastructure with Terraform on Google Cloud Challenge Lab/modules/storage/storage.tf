resource "google_storage_bucket" "tf_state" {
  name     = var.bucket_name

  project  = var.project_id

  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

