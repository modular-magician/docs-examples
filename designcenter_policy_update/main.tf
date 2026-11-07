resource "google_design_center_policy" "example" {
  project              = "my-project-name"
  location             = "us-central1"
  space                = "example-space"
  application_template = "example-template"
  policy_id            = "example-policy-${local.name_suffix}"
  display_name         = "Updated Example Policy"
  description          = "Updated Managed by Terraform"
  policy_type          = "COMPLIANCE_FRAMEWORK"
  policy_uri           = "projects/my-project-name/locations/global/frameworks/builtin-aipp"
}
