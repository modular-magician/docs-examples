resource "google_firestore_database" "database" {
  project     = "PROJECT_NAME"
  name        = "database-id-${local.name_suffix}"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"

  delete_protection_state = "DELETE_PROTECTION_ENABLED-${local.name_suffix}"
  deletion_policy         = "DELETE"
}

resource "google_firestore_field" "timestamp" {
  project    = "PROJECT_NAME"
  database   = google_firestore_database.database.name
  collection = "chatrooms"
  field      = "timestamp"

  # enables a TTL policy for the document based on the value of entries with this field
  ttl_config {}

  // Disable all single field indexes for the timestamp property.
  index_config {}
}
