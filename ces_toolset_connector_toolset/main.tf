data "google_project" "test_project" {}

resource "google_service_account" "connector_sa" {
  account_id   = "test-sa-${local.name_suffix}"
  display_name = "Service Account for Connector"
}

resource "google_integration_connectors_connection" "connector_toolset_connection" {
  name     = "test-connector-${local.name_suffix}"
  location = "us-central1"
  connector_version = "projects/${data.google_project.test_project.project_id}/locations/global/providers/gcp/connectors/pubsub/versions/1"
  description       = "Pub/Sub connector"
  service_account   = google_service_account.connector_sa.email
  
  config_variable {
      key = "project_id"
      string_value = data.google_project.test_project.project_id
  }
  config_variable {
      key = "topic_id"
      string_value = "test-topic"
  }
}

resource "google_ces_app" "ces_app_for_toolset" {
  app_id = "app-id-${local.name_suffix}"
  location = "us"
  description = "App used as parent for CES Toolset example"
  display_name = "my-app-${local.name_suffix}"

  language_settings {
    default_language_code    = "en-US"
    supported_language_codes = ["es-ES", "fr-FR"]
    enable_multilingual_support = true
    fallback_action          = "escalate"
  }
  time_zone_settings {
    time_zone = "America/Los_Angeles"
  }
}

resource "google_ces_toolset" "ces_toolset_connector_toolset" {
  toolset_id = "toolset1-${local.name_suffix}"
  location = "us"
  app      = google_ces_app.ces_app_for_toolset.app_id
  display_name = "Basic toolset display name"

  connector_toolset {
    connection = google_integration_connectors_connection.connector_toolset_connection.id
    connector_actions {
      connection_action_id = "publishMessage"
    }
  }
}
