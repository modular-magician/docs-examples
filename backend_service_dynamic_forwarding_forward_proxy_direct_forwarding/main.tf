resource "google_compute_backend_service" "default" {
  name                  = "backend-service-${local.name_suffix}"
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "HTTP2"
  dynamic_forwarding {
    forward_proxy {
      enabled    = true
      proxy_mode = "DIRECT_FORWARDING"
    }
  }
  tls_settings {
    authentication_config = "//networksecurity.googleapis.com/${google_network_security_backend_authentication_config.default.id}"
  }
}

resource "google_network_security_backend_authentication_config" "default" {
  name             = "authentication-${local.name_suffix}"
  well_known_roots = "PUBLIC_ROOTS"
}
