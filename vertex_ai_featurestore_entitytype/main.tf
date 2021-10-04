resource "google_vertex_ai_featurestore" "featurestore" {
  provider = google-beta
  name     = "terraform-${local.name_suffix}"
  labels = {
    foo = "bar"
  }
  region   = "us-central1"
  online_serving_config {
    fixed_node_count = 2
  }
}

resource "google_vertex_ai_featurestore_entitytype" "entity" {
  provider = google-beta
  name     = "terraform-${local.name_suffix}"
  labels = {
    foo = "bar"
  }
  featurestore = google_vertex_ai_featurestore.featurestore.id
  monitoring_config {
    snapshot_analysis {
      disabled = false
      monitoring_interval = "86400s"
    }
  }
}
