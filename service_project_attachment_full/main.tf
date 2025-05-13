resource "google_apphub_service_project_attachment" "example2" {
  service_project_attachment_id = google_project.service_project_full.project_id
  service_project = google_project.service_project_full.project_id
  depends_on = [time_sleep.wait_120s]
}

resource "google_project" "service_project_full" {
  project_id ="project-1-${local.name_suffix}"
  name = "Service Project Full"
  org_id = "ORG_ID"
  deletion_policy = "DELETE"
}

resource "time_sleep" "wait_120s" {
  depends_on = [google_project.service_project_full]

  create_duration = "120s"
}
