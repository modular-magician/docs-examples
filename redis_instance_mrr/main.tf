resource "google_redis_instance" "cache" {
  provider = google-beta
  name           = "mrr-memory-cache-${local.name_suffix}"
  tier           = "STANDARD_HA"
  memory_size_gb = 5

  location_id             = "us-central1-a"
  alternative_location_id = "us-central1-f"

  authorized_network = data.google_compute_network.redis-network.id

  redis_version     = "REDIS_6_X"
  display_name      = "Terraform Test Instance"
  reserved_ip_range = "192.168.0.0/28"
  replica_count     = 5
  read_replicas_mode = "READ_REPLICAS_ENABLED"

  labels = {
    my_key    = "my_val"
    other_key = "other_val"
  }
}

// This example assumes this network already exists.
// The API creates a tenant network per network authorized for a
// Redis instance and that network is not deleted when the user-created
// network (authorized_network) is deleted, so this prevents issues
// with tenant network quota.
// If this network hasn't been created and you are using this example in your
// config, add an additional network resource or change
// this from "data"to "resource"
data "google_compute_network" "redis-network" {
  name = "redis-test-network-${local.name_suffix}"
}
