resource "google_compute_global_address" "default" {
  name         = "global-address-premium-${local.name_suffix}"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}
