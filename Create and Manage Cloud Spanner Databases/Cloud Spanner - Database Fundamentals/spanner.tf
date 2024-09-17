resource "google_spanner_instance" "banking-instance-3" {
  name         = "banking-instance-3"
  config       = "regional-us-east1"
  display_name = "Banking Instance 3"
  num_nodes    = 2
  labels = {
  }
}
