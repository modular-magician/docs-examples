resource "google_storage_bucket" "bucket" {
  name                        = "my-bucket-${local.name_suffix}"
  location                    = "EU"
  uniform_bucket_level_access = true
  hierarchical_namespace {
    enabled = true
  }
}

resource "google_storage_folder" "folder" {
  bucket        = google_storage_bucket.bucket.name
  name          = "folder/name/"
  force_destroy = true
  recursive     = true
}
