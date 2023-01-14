resource "google_active_directory_domain" "ad-domain" {
  domain_name         = "tfgen-${local.name_suffix}.org.com"
  locations           = ["us-central1"]
  reserved_ip_range   = "192.168.255.0/24"
  authorized_networks = [google_compute_network.default.id]
}

resource "google_compute_network" "default" {
  name = "tfgen-${local.name_suffix}"
}
