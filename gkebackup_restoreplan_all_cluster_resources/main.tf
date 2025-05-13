resource "google_container_cluster" "primary" {
  name               = "all-groupkinds-${local.name_suffix}-cluster"
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
  name = "all-groupkinds-${local.name_suffix}"
  cluster = google_container_cluster.primary.id
  location = "us-central1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}

resource "google_gke_backup_restore_plan" "all_cluster_resources" {
  name = "all-groupkinds-${local.name_suffix}-rp"
  location = "us-central1"
  backup_plan = google_gke_backup_backup_plan.basic.id
  cluster = google_container_cluster.primary.id
  restore_config {
    no_namespaces = true
    namespaced_resource_restore_mode = "FAIL_ON_CONFLICT"
    cluster_resource_restore_scope {
      all_group_kinds = true
    }
    cluster_resource_conflict_policy = "USE_EXISTING_VERSION"
  }
}
