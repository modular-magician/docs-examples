resource "google_compute_region_backend_service" "default" {
  provider                        = google-beta
  name                            = "region-service-${local.name_suffix}"
  region                          = "us-central1"
  health_checks                   = [google_compute_region_health_check.health_check.id]
  connection_draining_timeout_sec = 10
  session_affinity                = "CLIENT_IP"
  protocol                        = "TCP"
  load_balancing_scheme           = "EXTERNAL"
  connection_tracking_policy {
    tracking_mode                                = "PER_SESSION"
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
    idle_timeout_sec                             = 60
    enable_strong_affinity                       = true
  }
}

resource "google_compute_region_health_check" "health_check" {
  provider           = google-beta
  name               = "rbs-health-check-${local.name_suffix}"
  region             = "us-central1"

  tcp_health_check {
    port = 22
  }
}
