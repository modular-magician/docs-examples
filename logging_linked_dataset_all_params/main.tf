resource "google_logging_project_bucket_config" "logging_linked_dataset" {
  location         = "global"
  project          = "PROJECT_NAME"
  enable_analytics = true
  bucket_id        = "my-bucket-${local.name_suffix}"
}

resource "google_logging_linked_dataset" "logging_linked_dataset" {
  link_id     = "mylink-${local.name_suffix}"
  bucket      = "my-bucket-${local.name_suffix}"
  parent      = "projects/PROJECT_NAME"
  location    = "global"
  description = "Linked dataset test"

  depends_on = ["google_logging_project_bucket_config.logging_linked_dataset"]
}
