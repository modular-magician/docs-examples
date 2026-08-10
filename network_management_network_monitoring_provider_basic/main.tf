resource "google_network_management_network_monitoring_provider" "provider" {
  network_monitoring_provider_id = "my-provider-${local.name_suffix}"
  location                       = "global"
  provider_type                  = "EXTERNAL"
}
