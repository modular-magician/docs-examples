resource "google_design_center_catalog_template_revision" "example" {
  project                              = "my-project-name"
  location                             = "us-central1"
  space                                = "example-space"
  catalog                              = "example-catalog"
  catalog_template                     = "example-application-catalog-template"
  revision_id                          = "example-app-revision-${local.name_suffix}"
  application_template_revision_source = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template/revisions/r-1"
}
