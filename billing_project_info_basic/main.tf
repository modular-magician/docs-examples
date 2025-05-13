resource "google_project" "project" {
  project_id = "tf-test%{random_suffix}"
  name       = "tf-test%{random_suffix}"
  org_id     = "ORG_ID"
  deletion_policy = "DELETE"
  lifecycle {
    ignore_changes = [billing_account]
  }
}

resource "google_billing_project_info" "default" {
  project         = google_project.project.project_id
  billing_account = "BILLING_ACCT"
}
