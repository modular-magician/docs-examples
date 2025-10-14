resource "google_compute_global_address" "default" {
  name               = "global-ipv6-address-${local.name_suffix}"
  address_type       = "EXTERNAL"
  ip_version         = "IPV6"
  ipv6_endpoint_type = "NETLB"
}
