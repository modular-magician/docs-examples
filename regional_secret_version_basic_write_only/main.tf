resource "google_secret_manager_regional_secret" "secret-basic-write-only" {
  secret_id = "secret-version-write-only-${local.name_suffix}"
  location = "us-central1"
}

resource "google_secret_manager_regional_secret_version" "regional_secret_version_basic_write_only" {
  secret = google_secret_manager_regional_secret.secret-basic-write-only.id
  secret_data_wo_version = 1
  secret_data_wo = "secret-data-write-only-${local.name_suffix}"
}
