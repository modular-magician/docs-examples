resource "google_storage_bucket" "bucket" {
  name = "test-bucket-${local.name_suffix}"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./path/to/zip/file/which/contains/code-${local.name_suffix}"
}

resource "google_cloudfunctions_function" "function" {
  name        = "function-test-${local.name_suffix}"
  description = "My function"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_url    = "gs://${google_storage_bucket_object.archive.bucket}/${google_storage_bucket_object.archive.output_name}"
  trigger_http          = true
  entry_point           = "helloGET"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
