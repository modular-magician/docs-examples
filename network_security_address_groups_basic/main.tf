resource "google_network_security_address_group" "default" {
  name        = "my-address-groups-${local.name_suffix}"
  parent      = "projects/PROJECT_NAME"
  location    = "us-central1"
  type        = "IPV4"
  capacity    = "100"
  items       = ["208.80.154.224/32"]
}
