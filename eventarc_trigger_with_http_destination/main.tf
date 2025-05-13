resource "google_eventarc_trigger" "primary" {
  name     = "some-trigger-${local.name_suffix}"
  location = "us-central1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    http_endpoint {
      uri = "http://10.77.0.0:80/route"
    }
    network_config {
      network_attachment = "projects/PROJECT_NAME/regions/us-central1/networkAttachments/"
    }
  }
  service_account = "SERVICE_ACCT"
}
