resource "google_compute_network" "network" {
  provider = google-beta
  name = "tf-test%{random_suffix}"
}

resource "google_compute_global_address" "service_range" {
  provider = google-beta
  name          = "tf-test%{random_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network.id
}

resource "google_service_networking_connection" "private_service_connection" {
  provider = google-beta
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}

resource "google_memcache_instance" "instance" {
  provider = google-beta
  name = "test-instance-${local.name_suffix}"
  region = "us-central1"
  authorized_network = google_service_networking_connection.private_service_connection.network

  node_config {
    cpu_count      = 1
    memory_size_mb = 1024
  }
  node_count = 1
}
