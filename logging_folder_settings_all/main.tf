resource "google_logging_folder_settings" "example" {
  disable_default_sink = true
  folder               = google_folder.my_folder.folder_id
  kms_key_name         = "kms-key-${local.name_suffix}"
  storage_location     = "us-central1"
  depends_on           = [ google_kms_crypto_key_iam_member.iam ]
}

resource "google_folder" "my_folder" {
  display_name = "folder-name-${local.name_suffix}"
  parent       = "organizations/ORG_ID"
  deletion_protection = false
}

data "google_logging_folder_settings" "settings" {
  folder = google_folder.my_folder.folder_id
}

resource "google_kms_crypto_key_iam_member" "iam" {
  crypto_key_id = "kms-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_logging_folder_settings.settings.kms_service_account_id}"
}
