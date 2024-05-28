resource "google_storage_bucket" "bucket" {
  name     = "bucket-name-${local.name_suffix}"
  location = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}

resource "google_storage_managed_folder" "managed_folder" {
  bucket = google_storage_bucket.bucket.name
  name   = "managed/folder/name-${local.name_suffix}"
}
