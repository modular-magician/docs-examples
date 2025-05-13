resource "google_firestore_database" "database" {
  project     = "PROJECT_NAME"
  name        = "database-id-vector-${local.name_suffix}"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"

  delete_protection_state = "DELETE_PROTECTION_DISABLED"
  deletion_policy         = "DELETE"
}

resource "google_firestore_index" "my-index" {
  project     = "PROJECT_NAME"
  database   = google_firestore_database.database.name
  collection = "atestcollection"

  fields {
    field_path = "field_name"
    order      = "ASCENDING"
  }

  fields {
    field_path = "__name__"
    order      = "ASCENDING"
  }

  fields {
    field_path = "description"
    vector_config {
      dimension = 128
      flat {}
    }
  }
}
