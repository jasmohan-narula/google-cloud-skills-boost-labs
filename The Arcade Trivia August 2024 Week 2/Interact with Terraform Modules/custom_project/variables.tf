variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  #FILL IN YOUR PROJECT ID HERE
  default     = "qwiklabs-gcp-04-783739d7c3de"

}

variable "name" {
  description = "Name of the buckets to create."
  type        = string
  #FILL IN A (UNIQUE) BUCKET NAME HERE"
  default     = "2024-terraform-test-qwiklabs-gcp-04-783739d7c3de"
}
