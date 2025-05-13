resource "google_logging_project_bucket_config" "logging_metric" {
    location  = "global"
    project   = "PROJECT_NAME"
    bucket_id = "_Default"
}

resource "google_logging_metric" "logging_metric" {
  name        = "my-(custom)/metric-${local.name_suffix}"
  filter      = "resource.type=gae_app AND severity>=ERROR"
  bucket_name = google_logging_project_bucket_config.logging_metric.id
}
