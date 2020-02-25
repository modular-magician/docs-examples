resource "google_compute_instance" "mirror" {
  name = "my-instance-${local.name_suffix}"
  provider = google-beta
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  zone = "us-east1-b"

  network_interface {
    network = google_compute_network.default.self_link
    access_config {
    }
  }
}

resource "google_compute_packet_mirroring" "foobar" {
  name = "my-mirroring-${local.name_suffix}"
  provider = google-beta
  description = "bar"
  network {
    url = google_compute_network.default.self_link
  }
  collector_ilb {
    url = google_compute_forwarding_rule.default.self_link
  }
  mirrored_resources {
    tags = ["foo"]
    instances {
      url = google_compute_instance.mirror.self_link
    }
  }
  filter {
    ip_protocols = ["tcp"]
    cidr_ranges = ["0.0.0.0/0"]
  }
}
resource "google_compute_network" "default" {
  name = "my-network-${local.name_suffix}"
  provider = google-beta
}

resource "google_compute_subnetwork" "default" {
  name = "my-subnetwork-${local.name_suffix}"
  provider = google-beta
  network       = google_compute_network.default.self_link
  ip_cidr_range = "10.2.0.0/16"

}

resource "google_compute_region_backend_service" "default" {
  name = "my-service-${local.name_suffix}"
  provider = google-beta
  region        = "us-east1"
  health_checks = ["${google_compute_health_check.default.self_link}"]
}

resource "google_compute_health_check" "default" {
  name = "my-healthcheck-${local.name_suffix}"
  provider = google-beta
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_forwarding_rule" "default" {
  depends_on = [google_compute_subnetwork.default]
  provider = google-beta
  name       = ""

  is_mirroring_collector = true
  ip_protocol            = "TCP"
  load_balancing_scheme  = "INTERNAL"
  backend_service        = google_compute_region_backend_service.default.self_link
  all_ports              = true
  network                = google_compute_network.default.self_link
  subnetwork             = google_compute_subnetwork.default.self_link
  network_tier           = "PREMIUM"
}
