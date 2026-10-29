resource "google_redis_cluster" "token-basic-cluster" {
  name                        = "token-basic-cluster-${local.name_suffix}"
  shard_count                 = 1
  region                      = "europe-west4"
  authorization_mode          = "AUTH_MODE_TOKEN_AUTH"
  deletion_protection_enabled = false
}

resource "google_redis_cluster_auth_token" "token-basic" {
  token_auth_user             = "${google_redis_cluster.token-basic-cluster.id}/tokenAuthUsers/default"
}
