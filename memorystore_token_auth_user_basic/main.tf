resource "google_memorystore_instance" "user-basic-instance" {
  instance_id                 = "user-basic-instance-${local.name_suffix}"
  shard_count                 = 1
  location                    = "us-central1"
  authorization_mode          = "TOKEN_AUTH"
  transit_encryption_mode     = "SERVER_AUTHENTICATION"
  deletion_protection_enabled = false
}

resource "google_memorystore_token_auth_user" "user-basic" {
  instance                    = google_memorystore_instance.user-basic-instance.name
  user_id                     = "user-basic-user-${local.name_suffix}"
}
