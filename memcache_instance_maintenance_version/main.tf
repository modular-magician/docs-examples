data "google_compute_network" "memcache_network" {
  name = "test-network-${local.name_suffix}"
}

resource "google_memcache_instance" "instance" {
  name = "test-instance-${local.name_suffix}"
  authorized_network = data.google_compute_network.memcache_network.id
  deletion_protection = false

  labels = {
    env = "test"
  }

  node_config {
    cpu_count      = 1
    memory_size_mb = 1024
  }
  node_count = 1
  memcache_version = "MEMCACHE_1_5"
  maintenance_version = "1.5.16"

  maintenance_policy {
    weekly_maintenance_window {
      day      = "SATURDAY"
      duration = "14400s"
      start_time {
        hours = 0
        minutes = 30
        seconds = 0
        nanos = 0
      }
    }
  }
}
