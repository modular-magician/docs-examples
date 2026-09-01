resource "google_integrations_integration_version" "version_basic" {
  location = "us-east4"
  integration = "test-integration-${local.name_suffix}"
  description = "Integration version created via terraform"
  new_integration = true
  create_sample_integrations = false
}
