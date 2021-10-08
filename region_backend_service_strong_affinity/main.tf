resource "google_compute_region_backend_service" "default" {
  name                            = "region-service-${local.name_suffix}"
  region                          = "us-west1"
  health_checks                   = [google_compute_region_health_check.health_check.id]
  connection_draining_timeout_sec = 10
  session_affinity                = "CLIENT_IP"
  protocol                        = "TCP"
  load_balancing_scheme           = "EXTERNAL"
  connection_tracking_policy {
    enable_strong_affinity = true
  }
}

resource "google_compute_region_health_check" "health_check" {
  name     = "rbs-health-check-${local.name_suffix}"
  region   = "us-west1"

  tcp_health_check {
    port = 22
  }
}
