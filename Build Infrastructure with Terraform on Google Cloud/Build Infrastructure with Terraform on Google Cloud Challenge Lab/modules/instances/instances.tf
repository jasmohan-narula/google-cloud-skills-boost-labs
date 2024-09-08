data "google_compute_image" "my_image" {
  name    = "debian-11-bullseye-v20240815"
  project = "debian-cloud"
}


resource "google_compute_instance" "tf-instance-1" {
  name = "tf-instance-1"
  //machine_type = "e2-micro"
  machine_type = "e2-standard-2"

  zone = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  /*
  network_interface {
    network = "default"
  }
*/

  network_interface {
    network    = var.vpc_network_name
    subnetwork = "subnet-01"
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT

  allow_stopping_for_update = true
}

resource "google_compute_instance" "tf-instance-2" {
  name = "tf-instance-2"
  //machine_type = "e2-micro"
  machine_type = "e2-standard-2"

  zone = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }



  /*
  network_interface {
    network = "default"
  }
*/

  network_interface {
    network    = var.vpc_network_name
    subnetwork = "subnet-02"
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT

  allow_stopping_for_update = true
}




// Uncomment to create the instance, comment out to delete/destroy the instance
/*
resource "google_compute_instance" "tf-instance-3" {
  name         = var.instance3_name
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }



  network_interface {
    network = "default"
  }


  allow_stopping_for_update = true
}
*/
