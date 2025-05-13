resource "google_eventarc_channel" "test_channel" {
  location             = "us-central1"
  name                 = "some-channel-${local.name_suffix}"
  crypto_key_name      = "some-key-${local.name_suffix}"
  third_party_provider = "projects/PROJECT_NAME/locations/us-central1/providers/datadog"
}

resource "google_cloud_run_service" "default" {
  name     = "some-service-${local.name_suffix}"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        ports {
          container_port = 8080
        }
      }
      container_concurrency = 50
      timeout_seconds       = 100
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_eventarc_trigger" "primary" {
  name     = "some-trigger-${local.name_suffix}"
  location = "us-central1"
  matching_criteria {
    attribute = "type"
    value     = "datadog.v1.alert"
  }
  destination {
    cloud_run_service {
      service = google_cloud_run_service.default.name
      region  = "us-central1"
    }
  }
  service_account = "SERVICE_ACCT"
  channel         = google_eventarc_channel.test_channel.id
}
