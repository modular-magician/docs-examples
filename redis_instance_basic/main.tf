resource "google_redis_instance" "cache" {
  name           = "memory-cache-${local.name_suffix}"
  memory_size_gb = 1
  deletion_protection = false

  lifecycle {
    prevent_destroy = false
  }
}
