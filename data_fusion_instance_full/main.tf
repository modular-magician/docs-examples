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
    ip_allocation = "10.89.48.0/22"
  }
  dataproc_service_account = data.google_app_engine_default_service_account.default.email
  # Mark for testing to avoid service networking connection usage that is not cleaned up
  options = {
    prober_test_run = "true"
  }
}

data "google_app_engine_default_service_account" "default" {
}
