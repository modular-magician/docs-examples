resource "google_project" "my_project" {
  name       = "tf-test-project"
  project_id = "ae-project-${local.name_suffix}"
  org_id     = "ORG_ID"
  billing_account = "BILLING_ACCT"
  deletion_policy = "DELETE"
}

resource "google_app_engine_application" "app" {
  project     = google_project.my_project.project_id
  location_id = "us-central"
}

resource "google_app_engine_firewall_rule" "rule" {
  project      = google_app_engine_application.app.project
  priority     = 1000
  action       = "ALLOW"
  source_range = "*"
}
