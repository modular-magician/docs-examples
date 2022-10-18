resource "google_compute_region_backend_service" "default" {
  name        = "region-service-${local.name_suffix}"
  description = "Coalescing Activated"
  enable_cdn  = true
  cdn_policy {
    request_coalescing = true
    signed_url_cache_max_age_sec = 7200
  }
}
