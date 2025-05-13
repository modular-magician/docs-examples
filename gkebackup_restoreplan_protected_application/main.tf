resource "google_container_cluster" "primary" {
  name               = "rollback-app-${local.name_suffix}-cluster"
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

resource "google_gke_backup_backup_plan" "basic" {
  name = "rollback-app-${local.name_suffix}"
  cluster = google_container_cluster.primary.id
  location = "us-central1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}

resource "google_gke_backup_restore_plan" "rollback_app" {
  name = "rollback-app-${local.name_suffix}-rp"
  location = "us-central1"
  backup_plan = google_gke_backup_backup_plan.basic.id
  cluster = google_container_cluster.primary.id
  restore_config {
    selected_applications {
      namespaced_names {
        name = "my-app"
        namespace = "my-ns"
      }
    }
    namespaced_resource_restore_mode = "DELETE_AND_RESTORE"
    volume_data_restore_policy = "REUSE_VOLUME_HANDLE_FROM_BACKUP"
    cluster_resource_restore_scope {
      no_group_kinds = true
    }
  }
}
