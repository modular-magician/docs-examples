resource "google_app_engine_application" "app" {
  project     = "tf-test-project-${local.name_suffix}"
  location_id = "us-central"
}

resource "google_storage_bucket" "bucket" {
  project  = "tf-test-project-${local.name_suffix}"
  name     = "tf-test-gae-bkt-bundled-${local.name_suffix}-${random_id.id.hex}"
  location = "US"
  uniform_bucket_level_access = true
}

resource "random_id" "id" {
  byte_length = 8
}

# Assume the object is made available by other means.
# resource "google_storage_bucket_object" "object" {
#   name   = "hello-world.zip-${local.name_suffix}"
#   bucket = google_storage_bucket.bucket.name
#   source = "./test-fixtures/hello-world.zip"
# }

resource "google_service_account" "service_account" {
  project      = "tf-test-project-${local.name_suffix}"
  account_id   = "gae-sa-bundled-${local.name_suffix}-${random_id.id.hex}"
  display_name = "Test Service Account for GAE"
}

resource "google_app_engine_standard_app_version" "gae-std-app-ver-bundled" {
  project      = google_app_engine_application.app.project
  version_id   = "v1"
  service      = "bundled-service-${local.name_suffix}-${random_id.id.hex}"
  runtime      = "python39"

  deployment {
    zip {
      # source_url = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
      source_url = "gs://${google_storage_bucket.bucket.name}/hello-world.zip-${local.name_suffix}"
    }
  }

  entrypoint {
    shell = "gunicorn -b :$PORT main:app"
  }

  env_variables = {
    port = "8080"
  }

  service_account = google_service_account.service_account.email

# Testing the app_engine_bundled_services field
  app_engine_bundled_services = ["BUNDLED_SERVICE_TYPE_MAIL", "BUNDLED_SERVICE_TYPE_DATASTORE_V3"]

  depends_on = [google_app_engine_application.app]
}
