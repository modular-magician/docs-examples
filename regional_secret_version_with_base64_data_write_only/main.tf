resource "google_secret_manager_regional_secret" "secret-basic" {
  secret_id = "secret-version-base64-write-only-${local.name_suffix}"
  location = "us-central1"
}

resource "google_secret_manager_regional_secret_version" "regional_secret_version_base64_write_only" {
  secret = google_secret_manager_regional_secret.secret-basic.id

  is_secret_data_base64 = true
  secret_data_wo_version = 1
  secret_data_wo = filebase64("secret-data-base64-write-only.pfx-${local.name_suffix}")
}
