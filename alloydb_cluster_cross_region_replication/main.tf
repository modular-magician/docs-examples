resource "google_alloydb_cluster" "default" {
  cluster_id   = "alloydb-cluster-full-${local.name_suffix}"
  location     = "us-central1"
  network      = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"

  initial_user {
    user     = "alloydb-cluster-full-${local.name_suffix}"
    password = "alloydb-cluster-full-${local.name_suffix}"
  }

  automated_backup_policy {
    location      = "us-central1"
    backup_window = "1800s"
    enabled       = true

    weekly_schedule {
      days_of_week = ["MONDAY"]

      start_times {
        hours   = 23
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }

    quantity_based_retention {
      count = 1
    }

    labels = {
      test = "alloydb-cluster-full-${local.name_suffix}"
    }
  }

  labels = {
    test = "alloydb-cluster-full-${local.name_suffix}"
  }
}

resource "google_alloydb_cluster" "default-secondary" {
  cluster_id   = ""
  location     = "us-east1"
  network      = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"

  create_secondary = true

  secondary_config {
    primary_cluster_name = google_alloydb_cluster.default.name
  }

  labels = {
    test = "alloydb-cluster-full-${local.name_suffix}"
  }

  depends_on [google_alloydb_cluster.default]
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-cluster-full-${local.name_suffix}"
}
