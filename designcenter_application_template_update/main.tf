resource "google_design_center_application_template" "example" {
  project                         = "my-project-name"
  location                        = "us-central1"
  space                           = "example-space"
  application_template_id         = "example-template-${local.name_suffix}"
  display_name                    = "Updated Example Application Template"
  description                     = "Updated Managed by Terraform"
  composition_type                = "COMPOSITE"
  inputs_as_root_module_variables = false

  application_parameters {
    key   = "project_id"
    value = jsonencode("my-project-name")
  }

  application_parameters {
    key   = "region"
    value = jsonencode("us-east1")
  }

  application_parameters {
    key   = "labels"
    value = jsonencode({ env = "test" })
  }

  root_input_variables {
    variable      = "service_name"
    component_uri = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template-${local.name_suffix}/components/example-component"
  }

  root_output_variables {
    variable      = "service_uri"
    component_uri = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template-${local.name_suffix}/components/example-component"
  }

  saas_runtime_context {
    saas_names = [
      "projects/my-project-name/locations/us-central1/saas/example-saas",
      "projects/my-project-name/locations/us-central1/saas/example-saas-2",
    ]
  }
}
