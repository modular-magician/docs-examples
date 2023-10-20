resource "google_network_connectivity_policy_based_route" "default" {
  name = "my-pbr-${local.name_suffix}"
  description = "My routing policy"
  network = google_compute_network.my_network.id
  priority = 2302

  filter {
    protocol_version = "IPV4"
    ip_protocol = "UDP"
    src_range = "10.0.0.0/24"
    dest_range = "0.0.0.0/0"
  }
  next_hop_ilb_ip = google_compute_global_address.ilb.address

  virtual_machine {
    tags = ["restricted"]
  }

  labels = {
    env = "default"
  }
}

resource "google_compute_network" "my_network" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

# This example substitutes an arbitrary internal IP for an internal network
# load balancer for brevity. Consult https://cloud.google.com/load-balancing/docs/internal
# to set one up.
resource "google_compute_global_address" "ilb" {
  name = "my-ilb-${local.name_suffix}"
}
