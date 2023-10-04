resource "google_compute_network" "default" {
    provider = google-beta
    name = "basic-network-${local.name_suffix}"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
    provider = google-beta
    name   = "basic-subnetwork-${local.name_suffix}"
    region = "us-central1"

    network       = google_compute_network.default.id
    ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_network_attachment" "default" {
    provider = google-beta
    name   = "basic-network-attachment-${local.name_suffix}"
    region = "us-central1"
    description = "my basic network attachment"

    subnetworks = [google_compute_subnetwork.default.id]
    connection_preference = "ACCEPT_AUTOMATIC"
}

resource "google_compute_instance" "default" {
    provider = google-beta
    name         = "basic-instance-${local.name_suffix}"
    zone         = "us-central1-a"
    machine_type = "e2-micro"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
        }
    }

    network_interface {
		network = "default"
	}

    network_interface {
        network_attachment = google_compute_network_attachment.default.self_link
    }
}
