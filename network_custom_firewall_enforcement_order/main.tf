resource "google_compute_network" "vpc_network" {
  project                                   = "PROJECT_NAME"
  name                                      = "vpc-network-${local.name_suffix}"
  auto_create_subnetworks                   = true
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
}
