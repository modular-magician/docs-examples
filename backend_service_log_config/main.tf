resource "google_compute_backend_service" "default" {
  name          = "backend-service-${local.name_suffix}"
  health_checks = [google_compute_http_health_check.default.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  log_config {
     enable      = true
     sample_rate = 1.0
     optional_mode = "CUSTOM"
     optional_fields = [ "orca.cpu_utilization", "orca.named_metrics.foo" ]
   }  
}

resource "google_compute_http_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
