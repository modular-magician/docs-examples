resource "google_agent_registry_service" "default" {
  location     = "us-central1"
  service_id   = "service-${local.name_suffix}"
  description  = "My Endpoint Agent Registry Service"
  display_name = "My Service"

  interfaces {
    url              = "https://example.com"
    protocol_binding = "HTTP_JSON"
  }

  endpoint_spec {
    type    = "NO_SPEC"
    content = "{}"
  }
}
