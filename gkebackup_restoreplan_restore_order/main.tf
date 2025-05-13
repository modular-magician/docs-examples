resource "google_container_cluster" "primary" {
  name               = "restore-order-${local.name_suffix}-cluster"
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
  name = "restore-order-${local.name_suffix}"
  cluster = google_container_cluster.primary.id
  location = "us-central1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}

resource "google_gke_backup_restore_plan" "restore_order" {
  name = "restore-order-${local.name_suffix}"
  location = "us-central1"
  backup_plan = google_gke_backup_backup_plan.basic.id
  cluster = google_container_cluster.primary.id
  restore_config {
    all_namespaces = true
    namespaced_resource_restore_mode = "FAIL_ON_CONFLICT"
    volume_data_restore_policy = "RESTORE_VOLUME_DATA_FROM_BACKUP"
    cluster_resource_restore_scope {
      all_group_kinds = true
    }
    cluster_resource_conflict_policy = "USE_EXISTING_VERSION"
    restore_order {
        group_kind_dependencies {
            satisfying {
                resource_group = "stable.example.com"
                resource_kind = "kindA"
            }
            requiring {
                resource_group = "stable.example.com"
                resource_kind = "kindB"
            }
        }
        group_kind_dependencies {
            satisfying {
                resource_group = "stable.example.com"
                resource_kind = "kindB"
            }
            requiring {
                resource_group = "stable.example.com"
                resource_kind = "kindC"
            }
        }
    }
  }
}
