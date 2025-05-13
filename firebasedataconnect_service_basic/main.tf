# Enable Firebase Data Connect API
resource "google_project_service" "fdc" {
  project = "PROJECT_NAME"
  service = "firebasedataconnect.googleapis.com"
  disable_on_destroy = false
}

# Create a Firebase Data Connect service
resource "google_firebase_data_connect_service" "default" {
  project = "PROJECT_NAME"
  location = "us-central1"
  service_id = "example-service-${local.name_suffix}"
  deletion_policy = "DEFAULT"

  labels = {
    label = "my-label"
  }

  annotations = {
    key1 = "value1",
    key2 = "value2",
  }

  depends_on = [google_project_service.fdc]
}
