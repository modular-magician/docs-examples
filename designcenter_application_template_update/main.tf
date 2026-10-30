resource "google_design_center_application_template" "example" {
  project                 = "my-project-name"
  location                = "us-central1"
  space                   = "example-space"
  application_template_id = "example-template-${local.name_suffix}"
  display_name            = "Updated Example Application Template"
  description             = "Updated Managed by Terraform"
}
