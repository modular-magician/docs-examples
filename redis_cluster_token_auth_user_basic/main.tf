resource "google_redis_cluster" "user-basic-cluster" {
  name                        = "user-basic-cluster-${local.name_suffix}"
  shard_count                 = 1
  region                      = "us-central1"
  authorization_mode          = "AUTH_MODE_TOKEN_AUTH"
  deletion_protection_enabled = false
}

resource "google_redis_cluster_token_auth_user" "user-basic" {
  cluster                     = google_redis_cluster.user-basic-cluster.id
  user_id                     = "user-basic-user-${local.name_suffix}"
}
