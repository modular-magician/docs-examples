data "google_project" "project" {
}

resource "google_cloudbuild_trigger" "webhook-trigger" {
  git_file_source {
    path = "someuri.com/cloudbuild.yaml"
    repo_type = "GITHUB"
    revision = "revision-tag"
  }
  webhook_config {
    secret = google_secret_manager_secret_version.secret-version-basic.name
  }
  source_to_build {
    uri = "someuri.com"
    repo_type = "GITHUB"
  }
}

resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version"

  labels = {
    label = "my-label"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = google_secret_manager_secret.secret-basic.id
  secret_data = "secret-data"
}

resource "google_secret_manager_secret_iam_member" "member" {
  project = google_secret_manager_secret.secret-basic.project
  secret_id = google_secret_manager_secret.secret-basic.secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}
