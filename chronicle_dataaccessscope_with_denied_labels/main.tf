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
  allow_all = true
  denied_data_access_labels {
    log_type = "GCP_CLOUDAUDIT"
  }
  denied_data_access_labels {
    data_access_label = resource.google_chronicle_data_access_label.custom_data_access_label.data_access_label_id
  }
  denied_data_access_labels {
    ingestion_label {
	    ingestion_label_key = "ingestion_key"
      ingestion_label_value = "ingestion_value"
    }
  }
  denied_data_access_labels {
    asset_namespace = "my-namespace"
  }
}
