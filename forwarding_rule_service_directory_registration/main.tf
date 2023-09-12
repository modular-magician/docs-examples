resource "google_compute_forwarding_rule" "default" {
  name       = "default"
  port_range = "80"
  target     = google_compute_target_pool.default.id
  service_directory_registrations {
    service = google_service_directory_service.default.service_id
    service_directory_region = "us-central1"
    namespace = google_service_directory_namespace.default.namespace_id
  }
}

resource "google_service_directory_namespace" "default" {
  namespace_id = "example-namespace"
  location     = "us-central1"
}

resource "google_service_directory_service" "default" {
  service_id = "example-service"
  namespace  = google_service_directory_namespace.default.id

  metadata = {
    stage  = "prod"
    region = "us-central1"
  }
}

resource "google_compute_target_pool" "default" {
  name = "target-pool-${local.name_suffix}"
}
