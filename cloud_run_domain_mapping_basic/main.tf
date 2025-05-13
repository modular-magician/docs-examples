
resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv-${local.name_suffix}"
  location = "us-central1"

  metadata {
    namespace = "PROJECT_NAME"
  }

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}

resource "google_cloud_run_domain_mapping" "default" {
  location = "us-central1"
  name     = "verified-domain.com"

  metadata {
    namespace = "PROJECT_NAME"
  }

  spec {
    route_name = google_cloud_run_service.default.name
  }
}
