data "google_project" "project" {}

resource "google_cloud_run_service" "default" {
  name     = "cloud-run-srv-${local.name_suffix}"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}
resource "google_cloud_run_domain_mapping" "default" {
  name     = "verified-domain-${local.name_suffix}"
  location = google_cloud_run_service.default.location
  metadata {
    namespace = data.google_project.project.project_id
  }
  spec {
    route_name = google_cloud_run_service.default.name
  }
}
