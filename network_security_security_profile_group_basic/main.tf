resource "google_network_security_security_profile_group" "default" {
  name                      = "sec-profile-group-${local.name_suffix}"
  parent                    = "organizations/ORG_ID"
  description               = "my description"
  threat_prevention_profile = google_network_security_security_profile.security_profile.id

  labels = {
    foo = "bar"
  }
}

resource "google_network_security_security_profile" "security_profile" {
    name        = "sec-profile-${local.name_suffix}"
    type        = "THREAT_PREVENTION"
    parent      = "organizations/ORG_ID"
    location    = "global"
}
