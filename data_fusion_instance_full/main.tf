data "google_data_fusion_instance_versions" "versions" {
  location = "us-central1"
}

resource "google_compute_network" "network" {
  name = "datafusion-full-network-${local.name_suffix}"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "datafusion-ip-alloc-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 22
  network       = google_compute_network.network.id
}

resource "google_data_fusion_instance" "extended_instance" {
  name = "my-instance-${local.name_suffix}"
  description = "My Data Fusion instance"
  region = "us-central1"
  type = "BASIC"
  enable_stackdriver_logging = true
  enable_stackdriver_monitoring = true
  labels = {
    example_key = "example_value"
  }
  private_instance = true
  network_config {
    network = "default"
    ip_allocation = "${google_compute_global_address.private_ip_alloc.address}/${google_compute_global_address.private_ip_alloc.prefix_length}"
  }
  version = data.google_data_fusion_instance_versions.versions.instance_versions[0].version_number
  dataproc_service_account = data.google_app_engine_default_service_account.default.email
}

data "google_app_engine_default_service_account" "default" {
}
