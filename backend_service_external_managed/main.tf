resource "google_compute_backend_service" "default" {
  provider = google-beta
  name          = "backend-service-${local.name_suffix}"
  health_checks = [google_compute_health_check.default.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_health_check" "default" {
  provider = google-beta
  name = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
