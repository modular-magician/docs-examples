resource "google_compute_network" "vpc_network" {
  project                                   = "PROJECT_NAME"
  name                                      = "vpc-network-${local.name_suffix}"
  routing_mode                              = "GLOBAL"
  bgp_best_path_selection_mode              = "STANDARD"
  bgp_always_compare_med                    = true
  bgp_inter_region_cost                     = "ADD_COST_TO_MED"
}
