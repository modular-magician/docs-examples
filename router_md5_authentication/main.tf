resource "google_compute_network" "network_havpn_ic" {
  name                    = "network-havpn-ic%{random_suffix}"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "subnet_havpn_ic" {
  name          = "subnet-havpn-ic%{random_suffix}"
  ip_cidr_range = "192.168.1.0/24"
  network       = google_compute_network.network_havpn_ic.self_link
}

resource "google_compute_router" "ic_router" {
  name                          = "ic-router%{random_suffix}"
  network                       = google_compute_network.network_havpn_ic.self_link
  encrypted_interconnect_router = true
  bgp {
    asn = 65000
  }
}

resource "google_compute_address" "address_vpn_ia_1" {
  name          = "address-vpn-ia-1%{random_suffix}"
  address_type  = "INTERNAL"
  purpose       = "IPSEC_INTERCONNECT"
  address       = "192.168.20.0"
  prefix_length = 29 # Allows you to reserve up to 8 IP addresses
  network       = google_compute_network.network_havpn_ic.self_link
}

resource "google_compute_address" "address_vpn_ia_2" {
  name          = "address-vpn-ia-2-%{random_suffix}"
  address_type  = "INTERNAL"
  purpose       = "IPSEC_INTERCONNECT"
  address       = "192.168.21.0"
  prefix_length = 29 # Allows you to reserve up to 8 IP addresses
  network       = google_compute_network.network_havpn_ic.self_link
}

data "google_project" "project" {
}

resource "google_compute_interconnect_attachment" "ia_1" {
  name    = "ia-1-%{random_suffix}"
  project = data.google_project.project.project_id
  router  = google_compute_router.ic_router.self_link
  # If you use the same project for your Dedicated Interconnect connection and attachments, you can keep the variable in the following URL.
  # If not, replace the URL and variable.
  interconnect = "https://www.googleapis.com/compute/v1/projects/${data.google_project.project.project_id}/global/interconnects/interconnect-zone1"
  description  = ""
  bandwidth    = "BPS_5G"
  type         = "DEDICATED"
  encryption   = "IPSEC"
  ipsec_internal_addresses = [
    google_compute_address.address_vpn_ia_1.self_link,
  ]
  vlan_tag8021q = 2001
}

resource "google_compute_interconnect_attachment" "ia_2" {
  name    = "ia-2-%{random_suffix}"
  project = data.google_project.project.project_id
  router  = google_compute_router.ic_router.self_link
  # If you use the same project for your Dedicated Interconnect connection and attachments, you can keep the variable in the following URL.
  # If not, replace the URL and variable.
  interconnect = "https://www.googleapis.com/compute/v1/projects/${data.google_project.project.project_id}/global/interconnects/interconnect-zone2"
  description  = ""
  bandwidth    = "BPS_5G"
  type         = "DEDICATED"
  encryption   = "IPSEC"
  ipsec_internal_addresses = [
    google_compute_address.address_vpn_ia_2.self_link,
  ]
  vlan_tag8021q = 2002
}

resource "google_compute_router_interface" "ic_if_1" {
  name                    = "ic-if-1-%{random_suffix}"
  router                  = google_compute_router.ic_router.name
  ip_range                = google_compute_interconnect_attachment.ia_1.cloud_router_ip_address
  interconnect_attachment = google_compute_interconnect_attachment.ia_1.self_link
}

resource "google_compute_router_interface" "ic_if_2" {
  name                    = "ic-if-2-%{random_suffix}"
  router                  = google_compute_router.ic_router.name
  ip_range                = google_compute_interconnect_attachment.ia_2.cloud_router_ip_address
  interconnect_attachment = google_compute_interconnect_attachment.ia_2.self_link
}

resource "google_compute_router_peer" "ic_peer_1" {
  name            = "ic-peer-1-%{random_suffix}"
  router          = google_compute_router.ic_router.name
  peer_ip_address = trimsuffix(google_compute_interconnect_attachment.ia_1.customer_router_ip_address, "/29")
  interface       = google_compute_router_interface.ic_if_1.name
  peer_asn        = 65098
}

resource "google_compute_router_peer" "ic_peer_2" {
  name            = "ic-peer-2-%{random_suffix}"
  router          = google_compute_router.ic_router.name
  peer_ip_address = trimsuffix(google_compute_interconnect_attachment.ia_2.customer_router_ip_address, "/29")
  interface       = google_compute_router_interface.ic_if_2.name
  peer_asn        = 65099
}

resource "google_compute_ha_vpn_gateway" "vpngw_1" {
  name    = "vpngw-1-%{random_suffix}"
  network = google_compute_network.network_havpn_ic.id
  vpn_interfaces {
    id                      = 0
    interconnect_attachment = google_compute_interconnect_attachment.ia_1.self_link
  }
  vpn_interfaces {
    id                      = 1
    interconnect_attachment = google_compute_interconnect_attachment.ia_2.self_link
  }
}

resource "google_compute_ha_vpn_gateway" "vpngw_2" {
  name    = "vpngw-2-%{random_suffix}"
  network = google_compute_network.network_havpn_ic.id
  vpn_interfaces {
    id                      = 0
    interconnect_attachment = google_compute_interconnect_attachment.ia_1.self_link
  }
  vpn_interfaces {
    id                      = 1
    interconnect_attachment = google_compute_interconnect_attachment.ia_2.self_link
  }
}

resource "google_compute_external_vpn_gateway" "external_vpngw_1" {
  name            = "external-vpngw-1-%{random_suffix}"
  redundancy_type = "TWO_IPS_REDUNDANCY"
  interface {
    id         = 0
    ip_address = "192.25.67.3"
  }
  interface {
    id         = 1
    ip_address = "192.25.67.4"
  }
}

resource "google_compute_external_vpn_gateway" "external_vpngw_2" {
  name            = "external-vpngw-2-%{random_suffix}"
  redundancy_type = "TWO_IPS_REDUNDANCY"
  interface {
    id         = 0
    ip_address = "192.25.68.5"
  }
  interface {
    id         = 1
    ip_address = "192.25.68.6"
  }
}

resource "google_compute_router" "vpn_router" {
  name    = "vpn-router-%{random_suffix}"
  network = google_compute_network.network_havpn_ic.self_link
  bgp {
    asn = 65010
  }

  md5_authentication_keys {
    name                    = "name1"
    key                     = "shared key 1-%{random_suffix}"
  }
  md5_authentication_keys {
    name                    = "name2"
    key                     = "shared key 2-%{random_suffix}"
  }
  md5_authentication_keys {
    name                    = "name3"
    key                     = "shared key 3-%{random_suffix}"
  }
  md5_authentication_keys {
    name                    = "name4"
    key                     = "shared key 4-%{random_suffix}"
  }
}

resource "google_compute_vpn_tunnel" "tunnel_1" {
  name                            = "tunnel-1-%{random_suffix}"
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpngw_1.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_vpngw_1.id
  shared_secret                   = "shhhhh"
  router                          = google_compute_router.vpn_router.id
  vpn_gateway_interface           = 0
  peer_external_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel_2" {
  name                            = "tunnel-2-%{random_suffix}"
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpngw_1.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_vpngw_1.id
  shared_secret                   = "shhhhh"
  router                          = google_compute_router.vpn_router.id
  vpn_gateway_interface           = 1
  peer_external_gateway_interface = 1
}

resource "google_compute_vpn_tunnel" "tunnel_3" {
  name                            = "tunnel-3-%{random_suffix}"
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpngw_2.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_vpngw_2.id
  shared_secret                   = "shhhhh"
  router                          = google_compute_router.vpn_router.id
  vpn_gateway_interface           = 0
  peer_external_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel_4" {
  name                            = "tunnel-4-%{random_suffix}"
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpngw_2.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_vpngw_2.id
  shared_secret                   = "shhhhh"
  router                          = google_compute_router.vpn_router.id
  vpn_gateway_interface           = 1
  peer_external_gateway_interface = 1
}

resource "google_compute_router_interface" "vpn_1_if_0" {
  name       = "vpn-1-if-0-%{random_suffix}"
  router     = google_compute_router.vpn_router.name
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_1.self_link
}

resource "google_compute_router_interface" "vpn_1_if_1" {
  name       = "vpn-1-if-1-%{random_suffix}"
  router     = google_compute_router.vpn_router.name
  ip_range   = "169.254.2.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_2.self_link
}

resource "google_compute_router_interface" "vpn_2_if_0" {
  name       = "vpn-2-if-0-%{random_suffix}"
  router     = google_compute_router.vpn_router.name
  ip_range   = "169.254.3.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_3.self_link
}

resource "google_compute_router_interface" "vpn_2_if_1" {
  name       = "vpn-2-if-1-%{random_suffix}"
  router     = google_compute_router.vpn_router.name
  ip_range   = "169.254.4.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_4.self_link
}

resource "google_compute_router_peer" "vpn_peer_1" {
  name            = "vpn-peer-1-%{random_suffix}"
  router          = google_compute_router.vpn_router.name
  peer_ip_address = "169.254.1.2"
  interface       = google_compute_router_interface.vpn_1_if_0.name
  peer_asn        = 65011
  md5_authentication_key_name     = google_compute_router.vpn_router.md5_authentication_keys[0].name
}

resource "google_compute_router_peer" "vpn_peer_2" {
  name            = "vpn-peer-2-%{random_suffix}"
  router          = google_compute_router.vpn_router.name
  peer_ip_address = "169.254.2.2"
  interface       = google_compute_router_interface.vpn_1_if_1.name
  peer_asn        = 65011
  md5_authentication_key_name     = google_compute_router.vpn_router.md5_authentication_keys[1].name
}

resource "google_compute_router_peer" "vpn_peer_3" {
  name            = "vpn-peer-3-%{random_suffix}"
  router          = google_compute_router.vpn_router.name
  peer_ip_address = "169.254.3.2"
  interface       = google_compute_router_interface.vpn_2_if_0.name
  peer_asn        = 65034
  md5_authentication_key_name     = google_compute_router.vpn_router.md5_authentication_keys[2].name
}

resource "google_compute_router_peer" "vpn_peer_4" {
  name            = "vpn-peer-4-%{random_suffix}"
  router          = google_compute_router.vpn_router.name
  peer_ip_address = "169.254.4.2"
  interface       = google_compute_router_interface.vpn_2_if_1.name
  peer_asn        = 65034
  md5_authentication_key_name     = google_compute_router.vpn_router.md5_authentication_keys[3].name
}
