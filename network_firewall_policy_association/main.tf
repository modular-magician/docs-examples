resource "google_compute_network_firewall_policy" "policy" {
  name = "my-policy-${local.name_suffix}"
  project = "PROJECT_NAME"
  description = "Sample global network firewall policy"
}

resource "google_compute_network" "network" {
  name = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_network_firewall_policy_association" "default" {
  name = "my-association-${local.name_suffix}"
  project = "PROJECT_NAME"
  attachment_target = google_compute_network.network.id
  firewall_policy =  google_compute_network_firewall_policy.policy.id
}
