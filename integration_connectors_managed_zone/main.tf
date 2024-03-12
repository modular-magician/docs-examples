data "google_project" "test_project" {
}

resource "google_integration_connectors_managed_zone" "samplemanagedzone" {
  name     = "test-managed-zone-${local.name_suffix}"
  description = "tf created description"
  labels = {
    intent = "example"
  }
  target_project="connectors-example"
  target_vpc="default"
  dns="connectors.example.com."
}
