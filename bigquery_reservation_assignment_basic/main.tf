resource "google_bigquery_reservation" "basic" {
  name  = "example-reservation-${local.name_suffix}"
  project = "PROJECT_NAME"
  location = "us-central1"
  slot_capacity = 0
  ignore_idle_slots = false
}

resource "google_bigquery_reservation_assignment" "assignment" {
  assignee  = "projects/PROJECT_NAME"
  job_type = "PIPELINE"
  reservation = google_bigquery_reservation.basic.id
}
