resource "google_project" "project" {
  project_id      = "project-id-${local.name_suffix}"
  name            = "project-id-${local.name_suffix}"
  org_id          = "ORG_ID"
  deletion_policy = "DELETE"
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [google_project.project]

  create_duration = "60s"
}

resource "google_project_service" "firestore" {
  project = google_project.project.project_id
  service = "firestore.googleapis.com"

  # Needed for CI tests for permissions to propagate, should not be needed for actual usage
  depends_on = [time_sleep.wait_60_seconds]
}

resource "google_firestore_database" "database" {
  project     = google_project.project.project_id
  name        = "(default)"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.firestore]
}

resource "google_firestore_document" "mydoc" {
  project     = google_project.project.project_id
  database    = google_firestore_database.database.name
  collection  = "somenewcollection"
  document_id = "my-doc-id-${local.name_suffix}"
  fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"akey\":{\"stringValue\":\"avalue\"}}}}}"
}

resource "google_firestore_document" "sub_document" {
  project     = google_project.project.project_id
  database    = google_firestore_database.database.name
  collection  = "${google_firestore_document.mydoc.path}/subdocs"
  document_id = "bitcoinkey"
  fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"ayo\":{\"stringValue\":\"val2\"}}}}}"
}

resource "google_firestore_document" "sub_sub_document" {
  project     = google_project.project.project_id
  database    = google_firestore_database.database.name
  collection  = "${google_firestore_document.sub_document.path}/subsubdocs"
  document_id = "asecret"
  fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"secret\":{\"stringValue\":\"hithere\"}}}}}"
}
