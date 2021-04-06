resource "google_compute_global_address" "default" {
  provider      = google-beta
  name          = "global-psconnect-ip-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  network       = google_compute_network.network.id
  address       = "100.100.100.106"
}

resource "google_compute_global_forwarding_rule" "default" {
  provider      = google-beta
  name          = "globalrule-${local.name_suffix}"
  target        = "all-apis"
  network       = google_compute_network.network.id
  ip_address    = google_compute_global_address.default.id
  load_balancing_scheme = ""
}

resource "google_compute_network" "network" {
  provider      = google-beta
  name          = "tf-test%{random_suffix}"
  auto_create_subnetworks = false
}
