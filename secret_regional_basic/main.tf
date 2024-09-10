resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-${local.name_suffix}"
  region = "us-central1"
  labels = {
    label = "my-label"
  }

}
