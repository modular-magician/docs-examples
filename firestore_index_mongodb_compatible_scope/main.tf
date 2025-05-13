resource "google_firestore_database" "database" {
	project                  = "PROJECT_NAME"
	name                     = "database-id-mongodb-compatible-${local.name_suffix}"
	location_id              = "nam5"
	type                     = "FIRESTORE_NATIVE"
	database_edition         = "ENTERPRISE"

	delete_protection_state = "DELETE_PROTECTION_DISABLED"
	deletion_policy         = "DELETE"
}

resource "google_firestore_index" "my-index" {
	project     = "PROJECT_NAME"
	database   = google_firestore_database.database.name
	collection = "atestcollection"

	api_scope   = "MONGODB_COMPATIBLE_API"
	query_scope = "COLLECTION_GROUP"
	multikey    = true
	density     = "DENSE"

	fields {
		field_path = "name"
		order      = "ASCENDING"
	}

	fields {
		field_path = "description"
		order      = "DESCENDING"
	}
}
