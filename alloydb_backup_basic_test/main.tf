resource "google_alloydb_backup" "default" {
  location     = "us-central1"
  backup_id    = "alloydb-backup-${local.name_suffix}"
  cluster_name = google_alloydb_cluster.default.name

  depends_on = [google_alloydb_instance.default]
}

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = data.google_compute_network.default.id
  }

  deletion_protection = false
}

resource "google_alloydb_instance" "default" {
  cluster           = google_alloydb_cluster.default.name
  instance_id       = "alloydb-instance-${local.name_suffix}"
  instance_type     = "PRIMARY"
  availability_type = "ZONAL"

  machine_config {
    cpu_count = 2
  }
}

data "google_compute_network" "default" {
  name = "alloydb-network-${local.name_suffix}"
}
