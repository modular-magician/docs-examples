resource "google_compute_firewall_policy" "default" {
  parent      = "organizations/ORG_ID"
  short_name  = "my-policy-${local.name_suffix}"
  description = "Example Resource"
}
