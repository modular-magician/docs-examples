resource "google_vertex_ai_metadata_store" "store" {
  provider      = google-beta
  name          = "test-schema-${local.name_suffix}"
  description   = "Store to test the terraform module"
  region        = "us-central1"
}

resource "google_vertex_ai_metadata_schema" "schema" {
  provider = google-beta
  description = "Schema to test the terraform module"
  metadatastore = google_vertex_ai_metadata_store.store.id
  schema = <<-EOT
    title: custom.Dataset
    version: 0.0.1
    type: object
    additionalProperties: false
    properties:
      container_format:
        type: string
      payload_format:
        type: string
  EOT
  schema_version = "0.0.1"
  schema_type = "ARTIFACT_TYPE"
}
