resource "google_storage_bucket" "bucket" {
  name     = "my-bucket-${local.name_suffix}"
  location = "US"
}

resource "google_storage_bucket_life_cycle_config" "bucketlifecycle" {
    depends_on = [google_storage_bucket.bucket]
    bucket = google_storage_bucket.bucket.name
    lifecycle_rule {
        action {
          type = "Delete"
        }
        condition {
          age        = 10
        }
    }
}
