resource "google_compute_network" "vpc_network" {
  project                 = "PROJECT_NAME"
  name                    = "vpc-network-${local.name_suffix}"
  auto_create_subnetworks = true
  mtu                     = 1460
}
