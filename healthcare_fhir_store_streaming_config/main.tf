resource "google_healthcare_fhir_store" "default" {
  name    = "example-fhir-store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id
  version = "R4"

  enable_update_create          = false
  disable_referential_integrity = false
  disable_resource_versioning   = false
  enable_history_import         = false

  labels = {
    label1 = "labelvalue1"
  }

  stream_configs {
    resource_types = ["Observation"]
    bigquery_destination {
      dataset_uri = "bq://${google_bigquery_dataset.bq_dataset.project}.${google_bigquery_dataset.bq_dataset.dataset_id}"
      schema_config {
        recursive_structure_depth = 3
      }
    }
  }

  depends_on = [
    google_project_iam_member.bigquery_editor,
    google_project_iam_member.bigquery_job_user
  ]
}

data "google_project" "project" {}

resource "google_project_iam_member" "bigquery_editor" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-healthcare.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "bigquery_job_user" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-healthcare.iam.gserviceaccount.com"
}

resource "google_pubsub_topic" "topic" {
  name     = "fhir-notifications-${local.name_suffix}"
}

resource "google_healthcare_dataset" "dataset" {
  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}

resource "google_bigquery_dataset" "bq_dataset" {
  dataset_id    = "bq_example_dataset-${local.name_suffix}"
  friendly_name = "test"
  description   = "This is a test description"
  location      = "US"
  delete_contents_on_destroy = true
}
