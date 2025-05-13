resource "google_chronicle_data_access_label" "example" {
  location = "us" 
  instance = "CHRONICLE_ID"
  data_access_label_id = "label-id-${local.name_suffix}"
  udm_query = "principal.hostname=\"google.com\""
  description = "label-description-${local.name_suffix}"
}
