resource "google_pubsub_schema" "example" {
  name = "example-${local.name_suffix}"
  type = "PROTOCOL_BUFFER"
  definition = "syntax = \"proto3\";\nmessage Results {\nstring message_request = 1;\nstring message_response = 2;\nstring timestamp_request = 3;\nstring timestamp_response = 4;\n}"
}

resource "google_pubsub_topic" "example" {
  name = "example-${local.name_suffix}-topic"

  depends_on = [google_pubsub_schema.example]
  schema_settings {
    schema = "projects/PROJECT_NAME/schemas/example-${local.name_suffix}"
    encoding = "JSON"
  }
}
