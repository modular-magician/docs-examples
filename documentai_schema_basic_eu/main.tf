resource "google_document_ai_schema" "schema" {
  location     = "eu-${local.name_suffix}"
  display_name = "test-schema-${local.name_suffix}"
}
