resource "google_sec_lm_workbench" "example" {
  workbench_id = "my-workbench-name-${local.name_suffix}"
  location = "us-central1"
  labels = {
    foo = "bar"
  }
}
