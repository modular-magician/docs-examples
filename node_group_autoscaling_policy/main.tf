resource "google_compute_node_template" "soletenant-tmpl" {
  provider = google-beta
  name      = "soletenant-tmpl-${local.name_suffix}"
  region    = "us-central1"
  node_type = "n1-node-96-624"
}

resource "google_compute_node_group" "nodes" {
  provider = google-beta
  name        = "soletenant-group-${local.name_suffix}"
  zone        = "us-central1-a"
  description = "example google_compute_node_group for Terraform Google Provider"

  size          = 1
  node_template = google_compute_node_template.soletenant-tmpl.id
  autoscaling_policy {
    mode = "ON"
    min_nodes = 1
    max_nodes = 10
  }
}
