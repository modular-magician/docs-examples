resource "google_compute_network" "net" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "my-subnetwork-${local.name_suffix}"
  region                   = "us-central1"
  network                  = google_compute_network.net.id
  ip_cidr_range            = "10.0.0.0/22"
  private_ip_google_access = true
}

# Destroy subnetwork 10 minutes after metastore service is deleted.
# It guarantees that the background PSC IP address cleanup has completed.
resource "time_sleep" "wait_10_minutes" {
  depends_on = [google_compute_subnetwork.subnet]

  destroy_duration = "10m"
}

resource "google_dataproc_metastore_service" "default" {
  service_id = "metastore-srv-${local.name_suffix}"
  location   = "us-central1"
  tier       = "DEVELOPER"

  hive_metastore_config {
    version = "3.1.2"
  }

  network_config {
    consumers {
      subnetwork = google_compute_subnetwork.subnet.id
    }
  }

  depends_on = [time_sleep.wait_10_minutes]
}
