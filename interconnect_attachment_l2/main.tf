resource "google_compute_interconnect_attachment" "on_prem" {
  name                     = "on-prem-attachment-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "L2_DEDICATED"
  router                   = google_compute_router.foobar.id
  mtu                      = 1500
  labels                   = { mykey = "myvalue" }

  l2_forwarding {
    network = google_compute_network.foobar.self_link
    geneve_header {
      vni = 1001
    }
    default_appliance_ip_address = "192.168.0.1"
    tunnel_endpoint_ip_address   = "192.168.0.2"
  }
}

resource "google_compute_router" "foobar" {
  name    = "router-1-${local.name_suffix}"
  network = google_compute_network.foobar.name
  bgp {
    asn = 16550
  }
}

resource "google_compute_network" "foobar" {
  name                    = "network-1-${local.name_suffix}"
  auto_create_subnetworks = false
}
