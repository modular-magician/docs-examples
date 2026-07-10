resource "google_network_services_mesh" "default" {
  name     = "my-mesh-${local.name_suffix}"
}

resource "google_network_services_telemetry_policy" "default" {
  name     = "my-telemetry-policy-${local.name_suffix}"
  location = "global"

  telemetry_target {
    resources = [google_network_services_mesh.default.id]
  }

  labels = {
    foo = "bar"
  }
}
