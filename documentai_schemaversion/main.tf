resource "google_document_ai_schema_version" "schema_version_id" {
  display_name = "schema_version"
  location     = "us"
  labels = {
    "label" = "key",
    "foo" = "bar",
  }
  schema {
    description     = "schema_description"
    display_name    = "schema_description"
    document_prompt = "document_prompt"
    entity_types {
      base_types   = ["document"]
      display_name = "entity_display_name"
      properties {
        display_name    = "property_display_name"
        method          = "EXTRACT"
        name            = "name"
        occurrence_type = "MULTIPLE_ONCE"
        value_type      = "string"
      }
    }
  }
  schema_id = "schema_id-${local.name_suffix}"
}
