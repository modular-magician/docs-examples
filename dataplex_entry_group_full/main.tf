resource "google_dataplex_entry_group" "test_entry_group_full" {
  entry_group_id = "entry-group-full-${local.name_suffix}"
  project = "PROJECT_NAME"
  location = "us-central1"

  labels = { "tag": "test-tf" }
  display_name = "terraform entry group"
  description = "entry group created by Terraform"
}
