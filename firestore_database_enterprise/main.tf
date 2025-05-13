resource "google_firestore_database" "enterprise-db" {
	project                  = "PROJECT_NAME"
	name                     = "database-id-${local.name_suffix}"
	location_id              = "nam5"
	type                     = "FIRESTORE_NATIVE"
	database_edition         = "ENTERPRISE"
	deletion_policy          = "DELETE"
}
