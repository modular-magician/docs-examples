resource "google_dns_managed_zone" "cloud-logging-enabled-zone" {
  name        = "cloud-logging-enabled-zone-${local.name_suffix}"
  dns_name    = "fmt.Sprintf("services.example.com-%s.", context["random_suffix"])-${local.name_suffix}"
  description = "Example cloud logging enabled DNS zone"
  labels = {
    foo = "bar"
  }

  cloud_logging_config {
    enable_logging = true
  }
}
