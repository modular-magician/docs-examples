resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

  schema_settings {
    schema = "topic-schema"
    encoding = "ENCODING_UNSPECIFIED"
  }
}
