resource "google_network_services_edge_cache_origin" "default" {
  provider             = google-beta
  name                 = "default-${local.name_suffix}"
  origin_address       = "gs://media-edge-default"
  description          = "The default bucket for media edge test"
}
