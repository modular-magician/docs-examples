resource "google_storage_bucket" "bucket" {
	name     = "appengine-static-content-${local.name_suffix}"
  location = "US"
}

data "archive_file" "app" {
  type        = "zip"
  source_dir = "./test-fixtures/hello-world-node-standard"
  output_path = "./test-fixtures/hello-world-node-standard.zip"
}

resource "google_storage_bucket_object" "object" {
  name   = "hello-world.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.app.output_path
}

resource "google_app_engine_standard_app_version" "internalapp" {
  version_id = "v1"
  service = "internalapp"
  delete_service_on_destroy = true

  runtime = "nodejs20"
  entrypoint {
    shell = "node ./app.js"
  }
  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }  
  }
  env_variables = {
    port = "8080"
  }
}

resource "google_app_engine_service_network_settings" "internalapp" {
  service = google_app_engine_standard_app_version.internalapp.service
  network_settings {
    ingress_traffic_allowed = "INGRESS_TRAFFIC_ALLOWED_INTERNAL_ONLY"
  }
}
