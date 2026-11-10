provider "google" {
  scopes = [
    "https://www.googleapis.com/auth/cloud-identity.allowlisteddomains",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

resource "google_cloud_identity_allowlisted_domain" "allowlisted_domain" {
  domain = "example.com-${local.name_suffix}"
}
