resource "google_storage_bucket" "bucket" {
  name     = "PROJECT_NAME-gcf-source-${local.name_suffix}"  # Every bucket name must be globally unique
  location = "US"
  uniform_bucket_level_access = true
}
 
resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.bucket.name
  source = "synthetic-fn-source.zip-${local.name_suffix}"  # Add path to the zipped function source code
}
 
resource "google_cloudfunctions2_function" "function" {
  name = "synthetic_function-${local.name_suffix}"
  location = "us-central1"
 
  build_config {
    runtime = "nodejs20"
    entry_point = "SyntheticFunction"  # Set the entry point 
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }
 
  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
  }
}

resource "google_monitoring_uptime_check_config" "synthetic_monitor" {
  display_name = "synthetic_monitor-${local.name_suffix}"
  timeout = "60s"

  synthetic_monitor {
    cloud_function_v2 {
      name = google_cloudfunctions2_function.function.id
    }
  }
}
