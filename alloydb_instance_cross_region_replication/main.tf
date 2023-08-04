resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance-${local.name_suffix}"
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = 2
  }

  depends_on = [
    google_service_networking_connection.vpc_connection, 
    google_alloydb_cluster.default
  ]
}

resource "google_alloydb_instance" "default-secondary" {
  cluster       = google_alloydb_cluster.default-secondary.name
  instance_id   = "alloydb-instance-secondary-${local.name_suffix}"
  instance_type = "SECONDARY"

  machine_config {
    cpu_count = 2
  }

  depends_on = [
    google_service_networking_connection.vpc_connection, 
    google_alloydb_cluster.default-secondary,
    google_alloydb_instance.default
  ]
}

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network    = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"

  initial_user {
    password = "alloydb-cluster-${local.name_suffix}"
  }

  labels = {
    test = "alloydb-cluster-${local.name_suffix}"
  }
}

resource "google_alloydb_cluster" "default-secondary" {
  cluster_id = "alloydb-cluster-secondary-${local.name_suffix}"
  location   = "us-east1"
  network    = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"
  
  create_secondary = true

  secondary_config {
    primary_cluster_name = google_alloydb_cluster.default.name
  }

  labels = {
    test = "alloydb-cluster-secondary-${local.name_suffix}"
  }

  depends_on = [google_alloydb_cluster.default]
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-network-${local.name_suffix}"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          =  "alloydb-cluster-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
