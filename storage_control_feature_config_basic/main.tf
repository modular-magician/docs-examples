resource "google_storage_bucket" "test_bucket" {
  name     = "example-bkt-${local.name_suffix}"
  location = "US"
}

resource "google_storage_control_feature_config" "example" {
  feature_config_id = "example-fc-${local.name_suffix}"
  description       = "Basic feature config for Auto Annotate"
  filter {
    included_cloud_storage_buckets {
      bucket_id_regexes = [google_storage_bucket.test_bucket.name]
    }
  }
  auto_annotate_config {
    processing_location = "us"
    models {
      name = "label-detector"
    }
  }
}
