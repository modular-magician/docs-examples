resource "google_secret_manager_secret" "secret-with-secret-type" {
  secret_id   = "secret-${local.name_suffix}"
  secret_type = "OTHER_DB_CREDENTIALS"

  replication {
    auto {}
  }
}
