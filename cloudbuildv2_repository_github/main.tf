resource "google_cloudbuildv2_repository" "primary" {
  name              = "repository-${local.name_suffix}"
  parent_connection = google_cloudbuildv2_connection.github_update.name
  remote_uri        = "https://github.com/gcb-repos-robot/tf-demo.git"
  location          = "us-central1"
  annotations       = {}
}

resource "google_cloudbuildv2_connection" "github_update" {
  location = "us-central1"
  name     = "connection-${local.name_suffix}"
  disabled = false

  github_config {
    app_installation_id = 31300675

    authorizer_credential {
      oauth_token_secret_version = "projects/gcb-terraform-creds/secrets/github-pat/versions/latest"
    }
  }

  annotations = {
    otherkey = "othervalue"

    somekey = "somevalue"
  }
}
