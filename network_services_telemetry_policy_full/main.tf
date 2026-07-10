resource "google_network_services_mesh" "default" {
  name     = "my-mesh-${local.name_suffix}"
}

resource "google_network_services_telemetry_policy" "default" {
  name         = "my-telemetry-policy-${local.name_suffix}"
  location     = "global"
  display_name = "my-telemetry-policy"

  telemetry_target {
    resources = [google_network_services_mesh.default.id]
  }

  tracing_configuration {
    sampling_rate = 0.5
    custom_span_attributes {
      attribute_name = "attribute-name"
      literal_value  = "literal-value"
    }
    parent_based_sampling {
      enabled       = true
      sampling_rate = 0.5
    }
  }

  metrics_configuration {
    enabled = true
  }

  labels = {
    foo = "bar"
  }
}
