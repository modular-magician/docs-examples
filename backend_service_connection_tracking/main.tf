resource "google_compute_backend_service" "default" {
  provider              = google-beta
  name                  = "backend-service-${local.name_suffix}"
  health_checks         = [google_compute_health_check.health_check.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  connection_tracking_policy {
    tracking_mode                                = "PER_SESSION"
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}

resource "google_compute_health_check" "health_check" {
  provider = google-beta
  name     = "health-check-${local.name_suffix}"

  http_health_check {
    port = 80
  }
}
