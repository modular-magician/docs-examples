resource "google_vertex_ai_pipeline_job" "pipeline_job" {
  name = "pipeline-job-${local.name_suffix}"
  location = "us-central1"
  runtime_config {
    gcs_output_directory = google_storage_bucket.bucket.url
    parameter_values = {
      model_display_name = "The display name for your model in the UI"
      large_model_reference = "text-bison@001"
      train_steps = 20
      project = data.google_project.project.project_id
      location = "us-central1"
      dataset_uri = google_storage_bucket_object.object.media_link
    }
  }
  template_uri = "https://us-kfp.pkg.dev/ml-pipeline/large-language-model-pipelines/tune-large-model/v2.0.0"
}

data "google_project" "project" {}

resource "google_storage_bucket" "bucket" {
  name     = "pipeline-job-bucket-${local.name_suffix}"
  location = "US"
}

resource "google_storage_bucket_object" "object" {
  name   = "pipeline-job-dataset-${local.name_suffix}"
  bucket = google_storage_bucket.bucket.name
  source = "./test-fixtures/dataset.jsonl"
}
