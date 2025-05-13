resource "google_pubsub_topic" "scc_v2_project_notification" {
  name = "my-topic-${local.name_suffix}"
}

resource "google_scc_v2_project_notification_config" "custom_notification_config" {
  config_id    = "my-config-${local.name_suffix}"
  project      = "PROJECT_NAME"
  location     = "global"
  description  = "My custom Cloud Security Command Center Finding Notification Configuration"
  pubsub_topic =  google_pubsub_topic.scc_v2_project_notification.id

  streaming_config {
    filter = "category = \"OPEN_FIREWALL\" AND state = \"ACTIVE\""
  }
}
