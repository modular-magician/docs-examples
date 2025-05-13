resource "google_project" "guest_project" {
  project_id      = "project-id-${local.name_suffix}"
  name            = "project-name-${local.name_suffix}"
  org_id          = "ORG_ID"
  deletion_policy = "DELETE"
}

resource "google_compute_node_template" "soletenant-tmpl" {
  name      = "soletenant-tmpl-${local.name_suffix}"
  region    = "us-central1"
  node_type = "n1-node-96-624"
}

resource "google_compute_node_group" "nodes" {
  name        = "soletenant-group-${local.name_suffix}"
  zone        = "us-central1-f"
  description = "example google_compute_node_group for Terraform Google Provider"

  initial_size          = 1
  node_template = google_compute_node_template.soletenant-tmpl.id

  share_settings {
    share_type = "SPECIFIC_PROJECTS"
    project_map {
      id = google_project.guest_project.project_id
      project_id = google_project.guest_project.project_id
    }
  }
}
