resource "google_cloudbuild_git_lab_config" "gitlab-config" {
    config_id = "gitlab-config-${local.name_suffix}"
    location = "us-central1"
    secrets {
        api_access_token_version = "projects/myProject/secrets/myGitLabPAT/versions/1"
        api_key_version = "projects/myProject/secrets/myApiKey/versions/1"
        read_access_token_version = "projects/myProject/secrets/myGitLabPAT/versions/1"
        webhook_secret_version = "projects/myProject/secrets/myWebhookSecret/versions/1"
    }
}
