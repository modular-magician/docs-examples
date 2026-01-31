resource "google_document_ai_schema" "schema" {
  display_name = "schema"
  location     = "us"
  labels = {
    "label" = "key",
    "foo" = "bar",
  }
}
