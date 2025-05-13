resource "google_project" "project" {
  project_id = "my-project-${local.name_suffix}"
  name       = "my-project-${local.name_suffix}"
  org_id     = "ORG_ID"
  deletion_policy = "DELETE"
}

resource "google_project_service" "project_service" {
  project = google_project.project.project_id
  service = "iap.googleapis.com"
}

resource "google_iap_brand" "project_brand" {
  support_email     = "support@ORG_DOMAIN"
  application_title = "Cloud IAP protected Application"
  project           = google_project_service.project_service.project
}

resource "google_iap_client" "project_client" {
  display_name = "Test Client"
  brand        =  google_iap_brand.project_brand.name
}
