resource "google_compute_backend_service" "default" {
  name                  = "backend-service-${local.name_suffix}"
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "HTTP2"
  dynamic_forwarding {
    forward_proxy {
      enabled    = true
      proxy_mode = "CLOUD_RUN"
    }
  }
}
