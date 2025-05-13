resource "google_dataplex_entry_group" "test_entry_group_basic" {
  entry_group_id = "entry-group-basic-${local.name_suffix}"
  project = "PROJECT_NAME"
  location = "us-central1"
}
