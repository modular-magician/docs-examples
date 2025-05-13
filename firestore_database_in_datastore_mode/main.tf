resource "google_firestore_database" "datastore_mode_database" {
  project                           = "PROJECT_NAME"
  name                              = "database-id-${local.name_suffix}"
  location_id                       = "nam5"
  type                              = "DATASTORE_MODE"
  concurrency_mode                  = "OPTIMISTIC"
  app_engine_integration_mode       = "DISABLED"
  point_in_time_recovery_enablement = "POINT_IN_TIME_RECOVERY_ENABLED"
  delete_protection_state           = "DELETE_PROTECTION_ENABLED-${local.name_suffix}"
  deletion_policy                   = "DELETE"
}
