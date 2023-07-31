resource "google_cloudbuild_trigger" "bbs-push-trigger" {
  name        = "bbs-push-trigger"
  location    = "us-central1"

  bitbucket_server_trigger_config {
    repo_slug = "bbs-push-trigger-${local.name_suffix}"
    project_key = "STAG"
    bitbucket_server_config_resource = "projects/123456789/locations/us-central1/bitbucketServerConfigs/myBitbucketConfig"
    push {
        tag = "^0.1.*"
        invert_regex = true
    }
  }

  filename = "cloudbuild.yaml"
}
