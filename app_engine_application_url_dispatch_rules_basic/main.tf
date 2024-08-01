resource "google_app_engine_application_url_dispatch_rules" "web_service" {
  dispatch_rules {
    domain  = "*"
    path    = "/*"
    service = "default"
  }

  dispatch_rules {
    domain  = "*"
    path    = "/admin/*"
    service = google_app_engine_standard_app_version.admin_v3.service
  }
}

resource "google_app_engine_standard_app_version" "admin_v3" {
  version_id = "v3"
  service    = "admin"
  runtime    = "nodejs20"

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

  delete_service_on_destroy = true
}

resource "google_storage_bucket" "bucket" {
  name     = "appengine-test-bucket-${local.name_suffix}"
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
