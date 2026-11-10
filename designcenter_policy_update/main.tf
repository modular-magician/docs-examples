data "google_project" "project" {
  project_id = "my-project-name"
}

resource "google_design_center_policy" "example" {
  project              = "my-project-name"
  location             = "us-central1"
  space                = "example-space"
  application_template = "example-template"
  policy_id            = "example-policy-${local.name_suffix}"
  display_name         = "Updated Example Policy"
  description          = "Updated Managed by Terraform"
  policy_type          = "COMPLIANCE_FRAMEWORK"
  policy_revision_uri  = "projects/${data.google_project.project.number}/locations/global/frameworks/builtin-us-data-boundary-and-support"

  apply_conditions {
    condition_key   = "environment"
    condition_value = "STAGING"
  }

  cloud_control_configs {
    cloud_control = "projects/${data.google_project.project.number}/locations/global/cloudControls/builtin-cloud-logging-storage-locations"

    parameters {
      key   = "cloudLoggingStorageLocations"
      value = jsonencode(["us-central1"])
    }
  }

  cloud_control_configs {
    cloud_control = "projects/${data.google_project.project.number}/locations/global/cloudControls/builtin-big-query-regulatory-settings"

    parameters {
      key   = "framework"
      value = jsonencode("US_DATA_BOUNDARY_AND_SUPPORT")
    }
  }
}
