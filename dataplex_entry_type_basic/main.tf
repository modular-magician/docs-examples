resource "google_dataplex_entry_type" "test_entry_type_basic" {
  entry_type_id = "entry-type-basic-${local.name_suffix}"
  project = "PROJECT_NAME"
  location = "us-central1"
}
