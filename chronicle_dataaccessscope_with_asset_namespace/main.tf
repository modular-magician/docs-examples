resource "google_chronicle_data_access_scope" "example" {
  location = "us"
  instance = "CHRONICLE_ID"
  data_access_scope_id = "scope-id-${local.name_suffix}"
  description = "scope-description-${local.name_suffix}"
  allowed_data_access_labels {
    asset_namespace = "my-namespace"
  }
}
