resource "google_developer_connect_git_repository_link" "primary" {
  git_repository_link_id = "my-repository-${local.name_suffix}"
  parent_connection = google_developer_connect_connection.github_enterprise_conn.connection_id
  clone_uri = "https://ghe.proctor-staging-test.com/proctorteam/inarayanan-test.git"
  location = "us-central1"
  annotations = {}
  labels = {}
}

resource "google_developer_connect_connection" "github_enterprise_conn" {
  
  location = "us-central1"
  connection_id = "my-connection-${local.name_suffix}"
  disabled = false

  github_enterprise_config {
    host_uri = "https://ghe.proctor-staging-test.com"
    app_id = 864434
    private_key_secret_version = "projects/devconnect-terraform-creds/secrets/tf-test-ghe-do-not-change-ghe-private-key-f522d2/versions/latest"
    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/tf-test-ghe-do-not-change-ghe-webhook-secret-3c806f/versions/latest"
    app_installation_id = 837537
  }
}
