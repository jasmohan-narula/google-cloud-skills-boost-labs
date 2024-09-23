provider "google" {
  project = var.project_id
  region  = var.default_region  # Set default region; subnets will override this
}

# Create a custom VPC network
resource "google_compute_network" "custom_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = false  # Custom subnets
}

# Create Subnet 1
resource "google_compute_subnetwork" "subnet_1" {
  name          = var.subnet_1_name
  network       = google_compute_network.custom_network.id
  ip_cidr_range = var.subnet_1_range
  region        = var.subnet_1_region
}

# Create Subnet 2
resource "google_compute_subnetwork" "subnet_2" {
  name          = var.subnet_2_name
  network       = google_compute_network.custom_network.id
  ip_cidr_range = var.subnet_2_range
  region        = var.subnet_2_region
}

# Create Subnet 3
resource "google_compute_subnetwork" "subnet_3" {
  name          = var.subnet_3_name
  network       = google_compute_network.custom_network.id
  ip_cidr_range = var.subnet_3_range
  region        = var.subnet_3_region
}



# Allow HTTP traffic from any source to instances with the 'http' tag
resource "google_compute_firewall" "allow_http" {
  name    = "nw101-allow-http"
  network = google_compute_network.custom_network.name

  # Target instances with the 'http' tag
  target_tags = ["http"]

  # Allow traffic from all IPv4 ranges (0.0.0.0/0)
  source_ranges = ["0.0.0.0/0"]

  # Allow TCP traffic on port 80 (HTTP)
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}




# Allow ICMP traffic to instances with the 'rules' tag
resource "google_compute_firewall" "allow_icmp" {
  name    = "nw101-allow-icmp"
  network = google_compute_network.custom_network.name

  # Target instances with the 'rules' tag
  target_tags = ["rules"]

  # Allow traffic from all IPv4 ranges (0.0.0.0/0)
  source_ranges = ["0.0.0.0/0"]

  # Allow ICMP protocol
  allow {
    protocol = "icmp"
  }
}


# Allow internal communication within the network (TCP, UDP, ICMP)
resource "google_compute_firewall" "allow_internal" {
  name    = "nw101-allow-internal"
  network = google_compute_network.custom_network.name

  # Allow traffic from the specified internal subnet ranges
  source_ranges = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]

  # Allow TCP on all ports
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  # Allow UDP on all ports
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  # Allow ICMP protocol
  allow {
    protocol = "icmp"
  }
}


# Allow SSH traffic to instances with the 'ssh' tag
resource "google_compute_firewall" "allow_ssh" {
  name    = "nw101-allow-ssh"
  network = google_compute_network.custom_network.name

  # Target instances with the 'ssh' tag
  target_tags = ["ssh"]

  # Allow traffic from all IPv4 ranges (0.0.0.0/0)
  source_ranges = ["0.0.0.0/0"]

  # Allow TCP traffic on port 22 (SSH)
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}


# Allow RDP traffic to all instances in the network
resource "google_compute_firewall" "allow_rdp" {
  name    = "nw101-allow-rdp"
  network = google_compute_network.custom_network.name

  # Allow traffic from all IPv4 ranges (0.0.0.0/0)
  source_ranges = ["0.0.0.0/0"]

  # Allow TCP traffic on port 3389 (RDP)
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}


