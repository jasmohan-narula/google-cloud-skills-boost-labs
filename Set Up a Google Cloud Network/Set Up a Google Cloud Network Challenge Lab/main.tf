provider "google" {
  project = var.project_id

}

# Create a custom VPC network
resource "google_compute_network" "custom_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = false # Custom subnets
  routing_mode            = "REGIONAL"
}

# Create Subnet 1
resource "google_compute_subnetwork" "subnet_1" {
  name          = var.subnet_1_name
  network       = google_compute_network.custom_network.id
  ip_cidr_range = var.subnet_1_ip_range
  region        = var.subnet_1_region

}

# Create Subnet 2
resource "google_compute_subnetwork" "subnet_2" {
  name          = var.subnet_2_name
  network       = google_compute_network.custom_network.id
  ip_cidr_range = var.subnet_2_ip_range
  region        = var.subnet_2_region
}


# Create firewall rule to allow SSH access
resource "google_compute_firewall" "firewall_rule_1_name" {
  name    = var.firewall_rule_1_name
  network = google_compute_network.custom_network.name

  # Firewall rule properties
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"] # Allow from any IPv4 address

  # Target all instances in the network
  target_tags = ["ssh"]

  # Allow TCP traffic on port 22 (SSH)
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}



# Create firewall rule to allow RDP access
resource "google_compute_firewall" "firewall_rule_2_name" {
  name    = var.firewall_rule_2_name
  network = google_compute_network.custom_network.name

  # Firewall rule properties
  direction     = "INGRESS"
  priority      = 65535
  source_ranges = ["0.0.0.0/24"] # Allow from specified IPv4 address range

  # Target all instances in the network
  target_tags = ["rdp"]

  # Allow TCP traffic on port 3389 (RDP)
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}


# Create firewall rule to allow ICMP traffic
resource "google_compute_firewall" "firewall_rule_3_name" {
  name    = var.firewall_rule_3_name
  network = google_compute_network.custom_network.name

  # Firewall rule properties
  direction     = "INGRESS"
  priority      = 65535
  source_ranges = ["0.0.0.0/24"] # Allow from specified IPv4 address range

  # Target all instances in the network
  target_tags = ["icmp"]

  # Allow ICMP traffic
  allow {
    protocol = "icmp"
  }
}







# Create VM Instance 1
resource "google_compute_instance" "vm_instance_1" {
  name         = var.instance_1_name
  machine_type = "e2-standard-2"
  zone         = var.instance_1_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.custom_network.id
    subnetwork = google_compute_subnetwork.subnet_1.id

    access_config { # This block allocates an external IP address
    }
  }

  allow_stopping_for_update = true


  tags = ["ssh", "rdp", "icmp"] # Make sure firewall rules apply to this instance
}

# Create VM Instance 2
resource "google_compute_instance" "vm_instance_2" {
  name         = var.instance_2_name
  machine_type = "e2-standard-2"
  zone         = var.instance_2_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.custom_network.id
    subnetwork = google_compute_subnetwork.subnet_2.id

    access_config { # This block allocates an external IP address
    }
  }

  allow_stopping_for_update = true


  tags = ["ssh", "rdp", "icmp"] # Make sure firewall rules apply to this instance
}
