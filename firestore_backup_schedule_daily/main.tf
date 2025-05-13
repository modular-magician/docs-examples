resource "google_firestore_database" "database" {
  project     = "PROJECT_NAME"
  name        = "database-id-${local.name_suffix}"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"

  delete_protection_state = "DELETE_PROTECTION_ENABLED-${local.name_suffix}"
  deletion_policy         = "DELETE"
}

resource "google_firestore_backup_schedule" "daily-backup" {
  project  = "PROJECT_NAME"
  database = google_firestore_database.database.name

  retention = "8467200s" // 14 weeks (maximum possible retention)

  daily_recurrence {}
}
