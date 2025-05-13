resource "google_chronicle_data_access_label" "custom_data_access_label" {
  location = "us"
  instance = "CHRONICLE_ID"
  data_access_label_id = "label-id-${local.name_suffix}"
  udm_query = "principal.hostname=\"google.com\""
}

resource "google_chronicle_data_access_scope" "example" {
  location = "us"
  instance = "CHRONICLE_ID"
  data_access_scope_id = "scope-id-${local.name_suffix}"
  description = "scope-description-${local.name_suffix}"
  allowed_data_access_labels {
    data_access_label = resource.google_chronicle_data_access_label.custom_data_access_label.data_access_label_id
  }
}
