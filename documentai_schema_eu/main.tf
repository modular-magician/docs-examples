resource "google_document_ai_schema_eu" "schema_eu" {
  display_name = "schema_eu"
  location     = "eu"
  labels = {
    "label" = "key",
    "foo" = "bar",
  }
}
