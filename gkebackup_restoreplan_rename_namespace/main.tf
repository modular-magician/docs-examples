resource "google_container_cluster" "primary" {
  name               = "rename-ns-${local.name_suffix}-cluster"
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
  name = "rename-ns-${local.name_suffix}"
  cluster = google_container_cluster.primary.id
  location = "us-central1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}

resource "google_gke_backup_restore_plan" "rename_ns" {
  name = "rename-ns-${local.name_suffix}-rp"
  location = "us-central1"
  backup_plan = google_gke_backup_backup_plan.basic.id
  cluster = google_container_cluster.primary.id
  restore_config {
    selected_namespaces {
      namespaces = ["ns1"]
    }
    namespaced_resource_restore_mode = "FAIL_ON_CONFLICT"
    volume_data_restore_policy = "REUSE_VOLUME_HANDLE_FROM_BACKUP"
    cluster_resource_restore_scope {
      no_group_kinds = true
    }
    transformation_rules {
      description = "rename namespace from ns1 to ns2"
      resource_filter {
        group_kinds {
          resource_kind = "Namespace"
        }
        json_path = ".metadata[?(@.name == 'ns1')]"
      }
      field_actions {
        op = "REPLACE"
        path = "/metadata/name"
        value = "ns2"
      }
    }
    transformation_rules {
      description = "move all resources from ns1 to ns2"
      resource_filter {
        namespaces = ["ns1"]
      }
      field_actions {
        op = "REPLACE"
        path = "/metadata/namespace"
        value = "ns2"
      }
    }
  }
}
