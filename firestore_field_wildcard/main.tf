resource "google_firestore_database" "database" {
	project     = "PROJECT_NAME"
	name        = "database-id-${local.name_suffix}"
	location_id = "nam5"
	type        = "FIRESTORE_NATIVE"

	delete_protection_state = "DELETE_PROTECTION_ENABLED-${local.name_suffix}"
	deletion_policy         = "DELETE"
  }

  resource "google_firestore_field" "wildcard" {
	project    = "PROJECT_NAME"
	database   = google_firestore_database.database.name
	collection = "chatrooms_%{random_suffix}"
	field      = "*"

	index_config {
	  indexes {
		  order       = "ASCENDING"
		  query_scope = "COLLECTION_GROUP"
	  }
	  indexes {
		  array_config = "CONTAINS"
	  }
	}
  }
