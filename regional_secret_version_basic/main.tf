resource "google_secret_manager_regional_secret" "secret-basic" {
  secret_id = "secret-version-${local.name_suffix}"
  location = "us-central1"
}

resource "google_secret_manager_regional_secret_version" "regional_secret_version_basic" {
  secret = google_secret_manager_regional_secret.secret-basic.id
  secret_data = "secret-data-${local.name_suffix}"
}
