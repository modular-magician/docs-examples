resource "google_monitoring_uptime_check_config" "cloud_run" {
  display_name = "cloud-run-uptime-check-${local.name_suffix}"
  timeout      = "60s"
  user_labels  = {
    example-key = "example-value"
  }

  http_check {
    path = "some-path"
    port = "443"
  }

  monitored_resource {
    type = "cloud_run_revision"
    labels = {
      location     = google_cloud_run_v2_service.default.location
      project_id   = google_cloud_run_v2_service.default.project
      service_name = google_cloud_run_v2_service.default.name
    }
  }
}

resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  ingress = "INGRESS_TRAFFIC_ALL"
  
  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
