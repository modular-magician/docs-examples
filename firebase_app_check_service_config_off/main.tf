resource "google_project_service" "appcheck" {
  project = "PROJECT_NAME"
  service = "firebaseappcheck.googleapis.com"
  disable_on_destroy = false
}

resource "google_firebase_app_check_service_config" "default" {
  project = "PROJECT_NAME"
  service_id = "firestore.googleapis.com-${local.name_suffix}"

  depends_on = [google_project_service.appcheck]
}
