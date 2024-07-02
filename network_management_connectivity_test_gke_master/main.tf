resource "google_network_management_connectivity_test" "gke-master-test" {
  name = "gke-master-test-${local.name_suffix}"
  source {
    forwarding_rule = google_compute_forwarding_rule.source.id
  }

  destination {
    forwarding_rule = google_compute_forwarding_rule.dest.id
  }

  protocol = "TCP"
  labels = {
    env = "test"
  }
}

resource "google_container_cluster" "source" {
  name     = "src-gke-${local.name_suffix}"
  location = "us-central1-a"

  deletion_protection      = "true-${local.name_suffix}"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_cluster" "dest" {
  name     = "dst-gke-${local.name_suffix}"
  location = "us-central1-a"

  deletion_protection      = "true-${local.name_suffix}"
  remove_default_node_pool = true
  initial_node_count       = 1
}
