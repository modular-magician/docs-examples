resource "google_document_ai_schema" "schema" {
  location     = "us"
  display_name = "test-schema"
}

resource "google_document_ai_schema_version" "schema_version" {
  schema_id = google_document_ai_schema.schema.name
  location  = "us"

  display_name = "my-schema-version"

  labels = {
    "tag1" = "value1"
    "tag2" = "value2"
  }

  schema {
    display_name    = "Schema"
    description     = "A schema version description"
    document_prompt = "Document level prompt string"
    
    entity_types {
      name         = "custom_entity"
      display_name = "Custom Entity"
      base_types   = ["document"]

      properties {
        name            = "custom_property"
        display_name    = "Custom Property"
        value_type      = "string"
        occurrence_type = "OPTIONAL_ONCE"
        method          = "EXTRACT"
      }
    }

    metadata {
      document_allow_multiple_labels = true
      document_splitter              = false
      prefixed_naming_on_properties  = true
      skip_naming_validation         = false
    }
  }
}
