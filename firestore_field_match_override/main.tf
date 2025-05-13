resource "google_firestore_database" "database" {
  project     = "PROJECT_NAME"
  name        = "database-id-${local.name_suffix}"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"

  delete_protection_state = "DELETE_PROTECTION_ENABLED-${local.name_suffix}"
  deletion_policy         = "DELETE"
}

resource "google_firestore_field" "match_override" {
  project    = "PROJECT_NAME"
  database   = google_firestore_database.database.name
  collection = "chatrooms_%{random_suffix}"
  field      = "field_with_same_configuration_as_ancestor"

  index_config {
    indexes {
        order = "ASCENDING"
    }
    indexes {
        order = "DESCENDING"
    }
    indexes {
        array_config = "CONTAINS"
    }
  }
}
