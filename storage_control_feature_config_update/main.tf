resource "google_storage_bucket" "test_bucket" {
  name     = "example-bkt-${local.name_suffix}"
  location = "US"
}

resource "google_storage_control_feature_config" "example" {
  feature_config_id = "example-fc-${local.name_suffix}"
  auto_annotate_config {
    processing_location = "eu"
    models {
      name = "object-detector"
    }
  }
}
