resource "google_firestore_database" "database" {
  project     = "PROJECT_NAME"
  name        = "database-id-dm-${local.name_suffix}"
  location_id = "nam5"
  type        = "DATASTORE_MODE"

  delete_protection_state = "DELETE_PROTECTION_DISABLED"
  deletion_policy         = "DELETE"
}

resource "google_firestore_index" "my-index" {
  project    = "PROJECT_NAME"
  database   = google_firestore_database.database.name
  collection = "atestcollection"

  query_scope = "COLLECTION_RECURSIVE"
  api_scope   = "DATASTORE_MODE_API"
  density     = "SPARSE_ALL"

  fields {
    field_path = "name"
    order      = "ASCENDING"
  }

  fields {
    field_path = "description"
    order      = "DESCENDING"
  }
}
