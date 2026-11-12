resource "google_design_center_connection" "example" {
  project                   = "my-project-name"
  location                  = "us-central1"
  space                     = "my-space"
  application_template      = "my-application-template"
  component                 = "my-source-component"
  connection_id             = "example-connection-${local.name_suffix}"
  destination_component_uri = "projects/my-project-name/locations/us-central1/spaces/my-space/applicationTemplates/my-application-template/components/my-dest-component"

  source_component_parameters {
    key   = "service_account_project_roles"
    value = jsonencode(["roles/cloudsql.client"])
  }

  destination_component_parameters {
    key = "iam_users"
    value = jsonencode([
      {
        id    = "example-sa"
        email = "example-sa@my-project-name.iam.gserviceaccount.com"
        type  = "CLOUD_IAM_SERVICE_ACCOUNT"
      },
    ])
  }
}
