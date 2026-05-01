resource "google_cloudbuild_git_lab_config" "gitlab-config" {
    config_id = "gitlab-config-${local.name_suffix}"
    location = "us-central1"
    username = "test-user"
    secrets {
        webhook_secret_version = "projects/myProject/secrets/mysecret/versions/1"
        api_key_version = "projects/myProject/secrets/mysecret/versions/1"
        api_access_token_version = "projects/myProject/secrets/mysecret/versions/1"
        read_access_token_version = "projects/myProject/secrets/mysecret/versions/1"
    }
}
