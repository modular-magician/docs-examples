resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.id
}

resource "google_pubsub_snapshot" "example" {
  name         = "example-snapshot-${local.name_suffix}"
  subscription = google_pubsub_subscription.example.name

  labels = {
    foo = "bar"
  }
}
