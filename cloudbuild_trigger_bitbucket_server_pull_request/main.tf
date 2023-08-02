resource "google_cloudbuild_trigger" "bbs-pull-request-trigger" {
  name        = "ghe-trigger-${local.name_suffix}"
  location    = "us-central1"

  bitbucket_server_trigger_config {
    repo_slug = "terraform-provider-google"
    project_key = "STAG"
    bitbucket_server_config_resource = "projects/123456789/locations/us-central1/bitbucketServerConfigs/myBitbucketConfig"
    pull_request {
        branch = "^master$"
        invert_regex = false
        comment_control = "COMMENTS_ENABLED"
    }
  }

  filename = "cloudbuild.yaml"
}
