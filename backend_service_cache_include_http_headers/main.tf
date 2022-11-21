resource "google_compute_backend_service" "default" {
  name          = "backend-service-${local.name_suffix}"
  enable_cdn  = true
  cdn_policy {
    cache_mode = "USE_ORIGIN_HEADERS"
    cache_key_policy {
      include_host = true
      include_protocol = true
      include_query_string = true
      include_http_headers = ["X-My-Header-Field"]
    }
  }
}
