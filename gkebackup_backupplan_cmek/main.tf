resource "google_container_cluster" "primary" {
  name               = "cmek-cluster-${local.name_suffix}"
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

resource "google_gke_backup_backup_plan" "cmek" {
  name = "cmek-plan-${local.name_suffix}"
  cluster = google_container_cluster.primary.id
  location = "us-central1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    selected_namespaces {
      namespaces = ["default", "test"]
    }
    encryption_key {
      gcp_kms_encryption_key = google_kms_crypto_key.crypto_key.id
    }
  }
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "backup-key-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_key_ring" "key_ring" {
  name     = "backup-key-${local.name_suffix}"
  location = "us-central1"
}
