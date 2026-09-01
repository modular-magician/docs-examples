resource "google_integrations_integration_version" "version_cmek" {
  location = "us-east4"
  integration = "test-integration-${local.name_suffix}"
  description = "Integration version with CMEK"
  cloud_kms_key = "kms-key-${local.name_suffix}"
}
