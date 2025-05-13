data "google_project" "project" {
}

resource "google_firestore_database" "database" {
  project                           = "PROJECT_NAME"
  name                              = "cmek-database-id-${local.name_suffix}"
  location_id                       = "nam5"
  type                              = "DATASTORE_MODE"
  concurrency_mode                  = "OPTIMISTIC"
  app_engine_integration_mode       = "DISABLED"
  point_in_time_recovery_enablement = "POINT_IN_TIME_RECOVERY_ENABLED"
  delete_protection_state           = "DELETE_PROTECTION_ENABLED-${local.name_suffix}"
  deletion_policy                   = "DELETE"
  cmek_config {
    kms_key_name                    = google_kms_crypto_key.crypto_key.id
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.firestore_cmek_keyuser
  ]
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "kms-key-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id
  purpose  = "ENCRYPT_DECRYPT"
}

resource "google_kms_key_ring" "key_ring" {
  name     = "kms-key-ring-${local.name_suffix}"
  location = "us"
}

resource "google_kms_crypto_key_iam_binding" "firestore_cmek_keyuser" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-firestore.iam.gserviceaccount.com",
  ]
}
