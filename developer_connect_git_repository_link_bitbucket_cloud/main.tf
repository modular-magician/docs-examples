resource "google_developer_connect_git_repository_link" "my-connection" {
  git_repository_link_id = "my-repository-${local.name_suffix}"
  parent_connection = google_developer_connect_connection.bbc_conn.connection_id
  clone_uri = "https://bitbucket.org/proctor-test-dc/inarayanan-test.git"
  location = "us-central1"
  annotations = {}
  labels = {}
}

resource "google_developer_connect_connection" "bbc_conn" {

  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"
  disabled = false

  bitbucket_cloud_config {
    workspace = "proctor-test-dc"

    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/bbc-webhook/versions/latest"

    read_authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbc-read-token/versions/latest"
    }

    authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbc-auth-token/versions/latest"
    }
  }
}
