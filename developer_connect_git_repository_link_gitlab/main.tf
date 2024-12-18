resource "google_developer_connect_git_repository_link" "my-connection" {
  git_repository_link_id = "my-repository-${local.name_suffix}"
  parent_connection = google_developer_connect_connection.gitlab_conn.connection_id
  clone_uri = "https://gitlab.com/devconnect-eng-team/inarayanan-test.git"
  location = "us-central1"
  annotations = {}
  labels = {}
}

resource "google_developer_connect_connection" "gitlab_conn" {
  
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"
  disabled = false

  gitlab_config {
    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-webhook/versions/latest"

    read_authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-read-cred/versions/latest"
    }

    authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-auth-cred/versions/latest"
    }
  }
}
