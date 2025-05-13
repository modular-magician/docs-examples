resource "google_monitoring_monitored_project" "primary" {
  metrics_scope = "PROJECT_NAME"
  name          = "locations/global/metricsScopes/PROJECT_NAME/projects/${google_project.basic.project_id}"
}

resource "google_project" "basic" {
  project_id = "m-id-${local.name_suffix}"
  name       = "m-id-${local.name_suffix}-display"
  org_id     = "ORG_ID"
  deletion_policy = "DELETE"
}
