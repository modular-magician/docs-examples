resource "google_compute_resource_policy" "default" {
  name   = "gce-policy-${local.name_suffix}"
  region = "us-central1"
  group_placement_policy {
    vm_count = 2
    collocation = "COLLOCATED"
    accelerator_topology_mode = "AUTO_CONNECT"
    slice_count = 2
  }
}
