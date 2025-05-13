resource "google_pubsub_topic" "scc_notification" {
  name = "my-topic-${local.name_suffix}"
}

resource "google_scc_notification_config" "custom_notification_config" {
  config_id    = "my-config-${local.name_suffix}"
  organization = "ORG_ID"
  description  = "My custom Cloud Security Command Center Finding Notification Configuration"
  pubsub_topic =  google_pubsub_topic.scc_notification.id

  streaming_config {
    filter = "category = \"OPEN_FIREWALL\" AND state = \"ACTIVE\""
  }
}
