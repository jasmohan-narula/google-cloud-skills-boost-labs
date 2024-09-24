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


output "instance_1_name" {
  value       = google_compute_instance.vm_instance_1.name
}

output "instance_2_name" {
  value       = google_compute_instance.vm_instance_2.name
}




output "instance_1_external_ip" {
  description = "The external IP address of VM Instance 1"
  value       = google_compute_instance.vm_instance_1.network_interface[0].access_config[0].nat_ip
}

output "instance_2_external_ip" {
  description = "The external IP address of VM Instance 2"
  value       = google_compute_instance.vm_instance_2.network_interface[0].access_config[0].nat_ip
}
