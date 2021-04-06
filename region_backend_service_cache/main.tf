resource "google_compute_region_backend_service" "default" {
  provider                        = google-beta
  name                            = "region-service-${local.name_suffix}"
  region                          = "us-central1"
  health_checks                   = [google_compute_region_health_check.default.id]
  enable_cdn  = true
  cdn_policy {
    cache_mode = "CACHE_ALL_STATIC"
    default_ttl = 3600
    client_ttl  = 7200
    max_ttl     = 10800
    negative_caching = true
    signed_url_cache_max_age_sec = 7200
  }

  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"

}

resource "google_compute_region_health_check" "default" {
  provider           = google-beta
  name               = "rbs-health-check-${local.name_suffix}"
  region             = "us-central1"

  http_health_check {
    port = 80
  }
}
