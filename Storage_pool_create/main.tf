resource "google_compute_network" "peering_network" {
  name = "peering-network"
}

# Create an IP address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.peering_network.id
}

# Create a private connection
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.peering_network.id
  service                 = "netapp.servicenetworking.goog"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "google_netapp_storage_pool" "testPools" {
  storage_pool_id = "testpool1"
  location = "us-central1"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = google_compute_network.peering_network.id
  active_directory      = ""
  description           = ""
  global_access_allowed = false
  kms_config            = ""
  labels                = {}
  ldap_enabled          = false
  psa_range             = ""

}
