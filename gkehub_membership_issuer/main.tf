resource "google_container_cluster" "primary" {
  name               = "basic-cluster-${local.name_suffix}"
  location           = "us-central1-a"
  initial_node_count = 1
  workload_identity_config {
    workload_pool = "PROJECT_NAME.svc.id.goog"
  }
  deletion_protection  = false
  network       = "default-${local.name_suffix}"
  subnetwork    = "default-${local.name_suffix}"
}

resource "google_gke_hub_membership" "membership" {
  membership_id = "basic-${local.name_suffix}"
  endpoint {
    gke_cluster {
      resource_link = google_container_cluster.primary.id
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/${google_container_cluster.primary.id}"
  }
}
