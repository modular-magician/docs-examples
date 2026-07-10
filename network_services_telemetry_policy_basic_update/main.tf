resource "google_network_services_mesh" "default" {
  name     = "my-mesh-${local.name_suffix}"
}

resource "google_network_services_telemetry_policy" "default" {
  name         = "my-telemetry-policy-${local.name_suffix}"
  location     = "global"
  display_name = "my-updated-telemetry-policy"

  telemetry_target {
    resources = [google_network_services_mesh.default.id]
  }

  metrics_configuration {
    enabled = false
  }

  labels = {
    foo = "bar2"
  }
}
