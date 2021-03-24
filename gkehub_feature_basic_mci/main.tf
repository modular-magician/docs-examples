resource "google_container_cluster" "primary" {
  name               = "basiccluster-${local.name_suffix}"
  location           = "us-central1-a"
  initial_node_count = 1
  provider = google-beta
}

resource "google_gke_hub_membership" "membership" {
  membership_id = "basic-${local.name_suffix}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.primary.id}"
    }
  }
  description = "test resource."
  provider = google-beta
}

resource "google_gke_hub_feature" "feature" {
  feature_id = "multiclusteringress"
  spec {
    multiclusteringress {
    	config_membership = google_gke_hub_membership.membership.id
	 }
  }
  provider = google-beta
}
