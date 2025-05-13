resource "google_pubsub_schema" "example" {
  name = "example-${local.name_suffix}"
  type = "AVRO"
  definition = "{\n  \"type\" : \"record\",\n  \"name\" : \"Avro\",\n  \"fields\" : [\n    {\n      \"name\" : \"StringField\",\n      \"type\" : \"string\"\n    },\n    {\n      \"name\" : \"IntField\",\n      \"type\" : \"int\"\n    }\n  ]\n}\n"
}

resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

  depends_on = [google_pubsub_schema.example]
  schema_settings {
    schema = "projects/PROJECT_NAME/schemas/example-${local.name_suffix}"
    encoding = "JSON"
  }
}
