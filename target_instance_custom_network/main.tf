resource "google_compute_target_instance" "custom_network" {
  name     = "custom-network-${local.name_suffix}"
  instance = google_compute_instance.target-vm.id
  network  = data.google_compute_network.target-vm.self_link
}

data "google_compute_network" "target-vm" {
  name = "default"
}

data "google_compute_image" "vmimage" {
  family  = "debian-10"
  project = "debian-cloud"
}

resource "google_compute_instance" "target-vm" {
  name         = "cusom-network-target-vm-${local.name_suffix}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.vmimage.self_link
    }
  }

  network_interface {
    network = "default"
  }
}
