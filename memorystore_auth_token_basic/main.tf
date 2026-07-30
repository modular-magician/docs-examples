resource "google_memorystore_instance" "token-basic-instance" {
  instance_id                 = "token-basic-instance-${local.name_suffix}"
  shard_count                 = 1
  location                    = "us-central1"
  authorization_mode          = "TOKEN_AUTH"
  transit_encryption_mode     = "SERVER_AUTHENTICATION"
  deletion_protection_enabled = false
}

resource "google_memorystore_token_auth_user" "token-basic-user" {
  instance                    = google_memorystore_instance.token-basic-instance.name
  user_id                     = "token-basic-user-${local.name_suffix}"
}

resource "google_memorystore_auth_token" "token-basic" {
  token_auth_user             = google_memorystore_token_auth_user.token-basic-user.id
}
