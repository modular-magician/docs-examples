resource "google_apphub_service_project_attachment" "example" {
  service_project_attachment_id = google_project.service_project.project_id
  depends_on = [time_sleep.wait_120s]
}

resource "google_project" "service_project" {
  project_id ="project-1-${local.name_suffix}"
  name = "Service Project"
  org_id = "ORG_ID"
  deletion_policy = "DELETE"
}

resource "time_sleep" "wait_120s" {
  depends_on = [google_project.service_project]

  create_duration = "120s"
}
