locals {
  project = "PROJECT_NAME" # Google Cloud Platform Project ID
}

resource "google_storage_bucket" "bucket" {
  name     = "${local.project}-gcf-source-${local.name_suffix}"  # Every bucket name must be globally unique
  location = "US"
  uniform_bucket_level_access = true
}
 
resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.bucket.name
  source = "function-source.zip-${local.name_suffix}"  # Add path to the zipped function source code
}

resource "google_cloudbuild_worker_pool" "pool" {
  name = "workerpool-${local.name_suffix}"
  location = "us-central1"
  worker_config {
    disk_size_gb = 100
    machine_type = "e2-standard-8"
    no_external_ip = false
  }
}
 
resource "google_cloudfunctions2_function" "function" {
  name = "function-workerpool-${local.name_suffix}"
  location = "us-central1"
  description = "a new function"
 
  build_config {
    runtime = "nodejs20"
    entry_point = "helloHttp"  # Set the entry point 
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
    worker_pool = google_cloudbuild_worker_pool.pool.id
  }
 
  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
  }
}
