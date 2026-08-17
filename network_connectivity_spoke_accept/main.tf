resource "google_compute_network" "network" {
  name                    = "net-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_connectivity_hub" "basic_hub" {
  name        = "hub1-${local.name_suffix}"
  description = "A sample hub"
}

resource "google_network_connectivity_spoke" "primary" {
  name     = "spoke-accept-${local.name_suffix}"
  location = "global"
  hub      = google_network_connectivity_hub.basic_hub.id
  auto_accept_hub = true

  linked_vpc_network {
    uri = google_compute_network.network.self_link
  }
}
