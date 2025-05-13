resource "google_logging_project_bucket_config" "logging_log_view" {
    project        = "PROJECT_NAME"
    location       = "global"
    retention_days = 30
    bucket_id      = "_Default"
}

resource "google_logging_log_view" "logging_log_view" {
  name        = "projects/PROJECT_NAME/locations/global/buckets/_Default/views/tf-test-view%{random_suffix}"
  bucket      = google_logging_project_bucket_config.logging_log_view.id
  description = "A logging view configured with Terraform"
  filter      = "SOURCE(\"projects/myproject\") AND resource.type = \"gce_instance\" AND LOG_ID(\"stdout\")"
}
