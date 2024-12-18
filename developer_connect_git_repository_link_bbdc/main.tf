resource "google_developer_connect_git_repository_link" "my-connection" {
  git_repository_link_id = "my-repository-${local.name_suffix}"
  parent_connection = google_developer_connect_connection.bbdc_conn.connection_id
  clone_uri = "https://bitbucket-us-central.gcb-test.com/scm/test/inarayanan-test.git"
  location = "us-central1"
  annotations = {}
  labels = {}
}

resource "google_developer_connect_connection" "bbdc_conn" {

  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"
  disabled = false

  bitbucket_data_center_config {
    host_uri = "https://bitbucket-us-central.gcb-test.com"

    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/bbdc-webhook/versions/latest"

    read_authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbdc-read-token/versions/latest"
    }

    authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbdc-auth-token/versions/latest"
    }
  }
}
