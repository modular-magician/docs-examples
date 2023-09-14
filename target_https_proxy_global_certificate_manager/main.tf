resource "google_compute_target_https_proxy" "default" {
  name             = "test-proxy-${local.name_suffix}"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [  "//certificatemanager.googleapis.com/${google_certificate_manager_certificate.default.id}"]
}

resource "google_certificate_manager_certificate" "default" {
  name        = "my-certificate-${local.name_suffix}"
  description = "certificate"
  scope       = "ALL_REGIONS"

  self_managed {
    pem_certificate = file("test-fixtures/cert.pem")
    pem_private_key = file("test-fixtures/private-key.pem")
  }
}

resource "google_compute_url_map" "default" {
  name        = "url-map-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.default.id
    }
  }
}

resource "google_compute_backend_service" "default" {
  name                  = "backend-service-${local.name_suffix}"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  load_balancing_scheme = "INTERNAL_MANAGED"

  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name = "http-health-check-${local.name_suffix}"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}
