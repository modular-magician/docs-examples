resource "google_logging_log_scope" "logging_log_scope" {
    parent         = "projects/PROJECT_NAME"
    location       = "global"
    name           = "projects/PROJECT_NAME/locations/global/logScopes/my-log-scope-${local.name_suffix}"
    resource_names = [
        "projects/PROJECT_NAME",
        "projects/PROJECT_NAME/locations/global/buckets/_Default/views/view1-${local.name_suffix}",
        "projects/PROJECT_NAME/locations/global/buckets/_Default/views/view2-${local.name_suffix}"
    ]
    description    = "A log scope configured with Terraform"
}
