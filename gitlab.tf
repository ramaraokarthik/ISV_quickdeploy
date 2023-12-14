provider "google" {
  credentials = file("~/gitlab.json")
  project     = "genai-for-partners"
  region      = "us-central1"
}

resource "google_compute_instance" "gitlab_vm" {
  name         = "gitlab-instance"
  machine_type = "n1-standard-2"  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"  
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<-SCRIPT
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y curl openssh-server ca-certificates
    sudo apt-get install -y postfix  # Choose "Internet Site" during installation

    # Install GitLab
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
    sudo EXTERNAL_URL="http://gitlab-instance" apt-get install gitlab-ce -y
  SCRIPT
}

output "external_ip" {
  value = google_compute_instance.gitlab_vm.network_interface.0.access_config.0.assigned_nat_ip
}
