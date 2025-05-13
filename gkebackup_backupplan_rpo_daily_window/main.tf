resource "google_container_cluster" "primary" {
  name               = "rpo-daily-cluster-${local.name_suffix}"
  location           = "us-central1"
  initial_node_count = 1
  workload_identity_config {
    workload_pool = "PROJECT_NAME.svc.id.goog"
  }
  addons_config {
    gke_backup_agent_config {
      enabled = true
    }
  }
  deletion_protection  = false
  network       = "default-${local.name_suffix}"
  subnetwork    = "default-${local.name_suffix}"
}

resource "google_gke_backup_backup_plan" "rpo_daily_window" {
  name = "rpo-daily-window-${local.name_suffix}"
  cluster = google_container_cluster.primary.id
  location = "us-central1"
  retention_policy {
    backup_delete_lock_days = 30
    backup_retain_days = 180
  }
  backup_schedule {
    paused = true
    rpo_config {
      target_rpo_minutes=1440
      exclusion_windows {
        start_time  {
          hours = 12
        }
        duration = "7200s"
        daily = true
      }
      exclusion_windows {
        start_time  {
          hours = 8
          minutes = 40
          seconds = 1
          nanos = 100
        }
        duration = "3600s"
        single_occurrence_date {
          year = 2024
          month = 3
          day = 16
        }
      }
    }
  }
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}
