resource "google_pubsub_topic" "topic" {
  name = "some-topic-${local.name_suffix}"
}

resource "google_eventarc_pipeline" "primary" {
  location    = "us-central1"
  pipeline_id = "some-pipeline-${local.name_suffix}"
  destinations {
    topic = google_pubsub_topic.topic.id
    network_config {
      network_attachment = "projects/PROJECT_NAME/regions/us-central1/networkAttachments/some-network-attachment-${local.name_suffix}"
    }
  }
  labels = {
    test_label = "test-eventarc-label"
  }
  annotations = {
    test_annotation = "test-eventarc-annotation"
  }
  display_name = "Testing Pipeline"
}
