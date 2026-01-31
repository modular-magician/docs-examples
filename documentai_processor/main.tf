resource "google_document_ai_processor" "processor" {
  location = "us"
  display_name = "test-processor-${local.name_suffix}"
  type = "OCR_PROCESSOR"
  default_processor_version = "default_processor_version"
  schema = "schema"
}
