resource "google_compute_network" "vpc_network" {
  project                                   = "PROJECT_NAME"
  name                                      = "vpc-network-${local.name_suffix}"
  routing_mode                              = "GLOBAL"
}
