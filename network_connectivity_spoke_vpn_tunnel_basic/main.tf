resource "google_network_connectivity_hub" "basic_hub" {
  name        = "basic-hub1-${local.name_suffix}"
  description = "A sample hub"
  labels = {
    label-two = "value-one"
  }
}

resource "google_compute_network" "network" {
  name                    = "basic-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "basic-subnetwork-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/28"
  region        = "us-central1"
  network       = google_compute_network.network.self_link
}

resource "google_compute_ha_vpn_gateway" "gateway" {
  name    = "vpn-gateway-${local.name_suffix}"
  network = google_compute_network.network.id
}

resource "google_compute_external_vpn_gateway" "external_vpn_gw" {
  name            = "external-vpn-gateway-${local.name_suffix}"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "An externally managed VPN gateway"
  interface {
    id         = 0
    ip_address = "8.8.8.8"
  }
}

resource "google_compute_router" "router" {
  name    = "external-vpn-gateway-${local.name_suffix}"
  region  = "us-central1"
  network = google_compute_network.network.name
  bgp {
    asn = 64514
  }
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name                            = "tunnel1-${local.name_suffix}"
  region                          = "us-central1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_vpn_gw.id
  peer_external_gateway_interface = 0
  shared_secret                   = "a secret message"
  router                          = google_compute_router.router.id
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name                            = "tunnel2-${local.name_suffix}"
  region                          = "us-central1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_vpn_gw.id
  peer_external_gateway_interface = 0
  shared_secret                   = "a secret message"
  router                          = " ${google_compute_router.router.id}"
  vpn_gateway_interface           = 1
}

resource "google_compute_router_interface" "router_interface1" {
  name       = "router-interface1-${local.name_suffix}"
  router     = google_compute_router.router.name
  region     = "us-central1"
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

resource "google_compute_router_peer" "router_peer1" {
  name                      = "router-peer1-${local.name_suffix}"
  router                    = google_compute_router.router.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_interface1.name
}

resource "google_compute_router_interface" "router_interface2" {
  name       = "router-interface2-${local.name_suffix}"
  router     = google_compute_router.router.name
  region     = "us-central1"
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "router_peer2" {
  name                      = "router-peer2-${local.name_suffix}"
  router                    = google_compute_router.router.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_interface2.name
}

resource "google_network_connectivity_spoke" "tunnel1" {
  name        = "vpn-tunnel-1-spoke-${local.name_suffix}"
  location    = "us-central1"
  description = "A sample spoke with a linked VPN Tunnel"
  labels = {
    label-one = "value-one"
  }
  hub = google_network_connectivity_hub.basic_hub.id
  linked_vpn_tunnels {
    uris                       = [google_compute_vpn_tunnel.tunnel1.self_link]
    site_to_site_data_transfer = true
    include_import_ranges      = ["ALL_IPV4_RANGES"]
  }
}

resource "google_network_connectivity_spoke" "tunnel2" {
  name        = "vpn-tunnel-2-spoke-${local.name_suffix}"
  location    = "us-central1"
  description = "A sample spoke with a linked VPN Tunnel"
  labels = {
    label-one = "value-one"
  }
  hub = google_network_connectivity_hub.basic_hub.id
  linked_vpn_tunnels {
    uris                       = [google_compute_vpn_tunnel.tunnel2.self_link]
    site_to_site_data_transfer = true
    include_import_ranges      = ["ALL_IPV4_RANGES"]
  }
}
