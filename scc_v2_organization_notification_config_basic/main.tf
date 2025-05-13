resource "google_pubsub_topic" "scc_v2_organization_notification_config" {
  name = "my-topic-${local.name_suffix}"
}

resource "google_scc_v2_organization_notification_config" "custom_organization_notification_config" {
  config_id    = "my-config-${local.name_suffix}"
  organization = "ORG_ID"
  location     = "global"
  description  = "My custom Cloud Security Command Center Finding Organization Notification Configuration"
  pubsub_topic = google_pubsub_topic.scc_v2_organization_notification_config.id

  streaming_config {
    filter = "category = \"OPEN_FIREWALL\" AND state = \"ACTIVE\""
  }
}
