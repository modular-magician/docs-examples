resource "google_network_security_security_profile" "default" {
  name        = "my-security-profile-${local.name_suffix}"
  parent      = "organizations/ORG_ID"
  description = "my description"
  type        = "THREAT_PREVENTION"

  labels = {
    foo = "bar"
  }
}
