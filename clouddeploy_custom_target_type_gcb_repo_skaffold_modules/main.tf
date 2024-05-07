resource "google_clouddeploy_custom_target_type" "custom-target-type" {
    location = "us-central1"
    name = "my-custom-target-type-${local.name_suffix}"
    description = "My custom target type"
    custom_actions {
      render_action = "renderAction"
      deploy_action = "deployAction"
      include_skaffold_modules {
        configs = ["my-config"]
        google_cloud_build_repo {
            repository = "projects/example/locations/us-central1/connections/git/repositories/example-repo"
            path = "configs/skaffold.yaml"
            ref = "main"
        }
      }
    }
}
