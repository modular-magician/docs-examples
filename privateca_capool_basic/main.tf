resource "google_privateca_ca_pool" "default" {
  name = "my-pool-${local.name_suffix}"
  location = "us-central1"
  tier = "ENTERPRISE"
}
