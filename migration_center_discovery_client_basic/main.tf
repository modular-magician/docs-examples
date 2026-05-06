resource "google_migration_center_source" "default" {
  location  = "us-central1"
  source_id = "source-test-${local.name_suffix}"
  type      = "SOURCE_TYPE_DISCOVERY_CLIENT"
}

resource "google_service_account" "default" {
  account_id   = "sa-test-${local.name_suffix}"
  display_name = "Service Account for Discovery Client"
}

resource "google_migration_center_discovery_client" "default" {
  location            = "us-central1"
  discovery_client_id = "discovery-client-test-${local.name_suffix}"
  source              = google_migration_center_source.default.id
  service_account     = google_service_account.default.email
  display_name        = "Terraform integration test display"
  description         = "Terraform integration test description"
  expire_time         = "2030-01-01T00:00:00Z"
  labels = {
    key = "value"
  }
}
