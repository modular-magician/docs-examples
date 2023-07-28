resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance-${local.name_suffix}"
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = 2
  }

  depends_on = [google_service_networking_connection.vpc_connection]
}

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network    = data.google_compute_network.default.id

  initial_user {
    password = "alloydb-cluster-${local.name_suffix}"
  }
}

data "google_project" "project" {}

data "google_compute_network" "default" {
  name = "alloydb-network-${local.name_suffix}"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          =  "alloydb-cluster-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = data.google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
