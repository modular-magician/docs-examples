resource "google_bigquery_reservation" "reservation" {
  name              = "my-reservation-${local.name_suffix}"
  location          = "us-west2"
  slot_capacity     = 0
  edition           = "ENTERPRISE"
  ignore_idle_slots = false
  reservation_group = google_bigquery_reservation_group.reservation_group.id
}

resource "google_bigquery_reservation_group" "reservation_group" {
  name     = "tf-test-group"
  location = "us-west2"
}
