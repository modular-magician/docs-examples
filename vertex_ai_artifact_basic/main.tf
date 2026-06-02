resource "google_vertex_ai_metadata_store" "store" {
  name        = "store-${local.name_suffix}"
  description = "Store to test Artifact"
  region      = "us-central1"
}

resource "google_vertex_ai_artifact" "artifact" {
  artifact_id    = "artifact-${local.name_suffix}"
  metadatastore  = google_vertex_ai_metadata_store.store.name
  location       = "us-central1"
  schema_title   = "system.Dataset"
  schema_version = "0.0.1"
  uri            = "https://example.com/dataset"
  state          = "PENDING"
  
  metadata = {
    key = "value"
  }
}
