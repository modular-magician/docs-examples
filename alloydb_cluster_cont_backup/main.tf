resource "google_alloydb_cluster" "default" {
  provider = google-beta

  cluster_id = "alloydb-cont-${local.name_suffix}"
  location   = "us-central1"
  network    = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"

  continuous_backup_config {
    recovery_window_days = 7
    enabled              = true
  }
}

data "google_project" "project" {
  provider = google-beta
}

resource "google_compute_network" "default" {
  provider = google-beta

  name = "alloydb-cont-${local.name_suffix}"
}
