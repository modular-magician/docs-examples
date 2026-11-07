resource "google_design_center_catalog_template_revision" "example" {
  project          = "my-project-name"
  location         = "us-central1"
  space            = "example-space"
  catalog          = "example-catalog"
  catalog_template = "example-catalog-template"
  revision_id      = "example-revision-${local.name_suffix}"
  description      = "Example catalog template revision"
  type             = "SERVICE"

  git_source {
    repo    = "GoogleCloudPlatform/terraform-google-cloud-run"
    dir     = "modules/v2"
    ref_tag = "v0.15.2"
  }
}
