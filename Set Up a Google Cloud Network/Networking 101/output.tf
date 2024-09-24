output "vpc_network_name" {
  description = "The name of the custom VPC network"
  value       = google_compute_network.custom_network.name
}

output "subnet_1_name" {
  description = "The name of the first subnet"
  value       = google_compute_subnetwork.subnet_1.name
}

output "subnet_2_name" {
  description = "The name of the second subnet"
  value       = google_compute_subnetwork.subnet_2.name
}

output "subnet_3_name" {
  description = "The name of the third subnet"
  value       = google_compute_subnetwork.subnet_3.name
}
