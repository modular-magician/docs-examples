resource "google_compute_backend_service" "default" {
  name          = "backend-service-${local.name_suffix}"
  health_checks = [google_compute_http_health_check.default.id]
  enable_cdn  = true
  cdn_policy {
    cache_mode = "CACHE_ALL_STATIC"
    default_ttl = 3600
    client_ttl  = 7200
    max_ttl     = 10800
    negative_caching = true
    signed_url_cache_max_age_sec = 7200

    bypass_cache_on_request_headers {
      header_name = "Authorization"
    }

    bypass_cache_on_request_headers {
      header_name = "Proxy-Authorization"
    }
  }
}

resource "google_compute_http_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
