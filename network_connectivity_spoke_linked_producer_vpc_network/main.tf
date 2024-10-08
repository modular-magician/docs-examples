resource "google_compute_network" "network" {
  provider                = google-beta
  name                    = "net-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_connectivity_hub" "hub" {
  provider    = google-beta
  name        = "hub-${local.name_suffix}"
}

# reserve private range for service networking
resource "google_compute_global_address" "range" {
  provider      = google-beta
  name          = "psa-range-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network.id
}

# create service networking connection
resource "google_service_networking_connection" "default" {
  provider                = google-beta
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.range.name]
}

# attach the consumer VPC to the hub
resource "google_network_connectivity_spoke" "consumer" {
  provider = google-beta
  name     = "consumer-vpc-spoke-${local.name_suffix}"
  location = "global"
  hub      = google_network_connectivity_hub.hub.id
  linked_vpc_network {
    uri = google_compute_network.network.id
  }
}

# attach the producer VPC to the hub
resource "google_network_connectivity_spoke" "producer"  {
  provider = google-beta
  name     = "producer-vpc-spoke-${local.name_suffix}"
  location = "global"
  hub      = google_network_connectivity_hub.hub.id
  linked_producer_vpc_network {
    exclude_export_ranges = ["10.10.0.0/16"]
    include_export_ranges = ["10.0.0.0/8"]
    network = google_compute_network.network.id
    peering = google_service_networking_connection.default.peering
  }

  # producer vpc spoke can only be attached after attaching the
  # consumer vpc
  depends_on = [    
    google_network_connectivity_spoke.consumer
  ]
}
