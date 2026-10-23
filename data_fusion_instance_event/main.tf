resource "google_data_fusion_instance" "event" {
  name    = "my-instance-${local.name_suffix}"
  region  = "us-central1"
  type    = "BASIC"

  event_publish_config {
    enabled = true
    topic   = google_pubsub_topic.event.id
  }
  -${local.name_suffix}
}

resource "google_pubsub_topic" "event" {
  name = "my-instance-${local.name_suffix}"
}
