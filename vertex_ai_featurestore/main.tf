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
