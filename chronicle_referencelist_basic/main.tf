resource "google_chronicle_reference_list" "example" {
 location = "us"
 instance = "CHRONICLE_ID"
 reference_list_id = "reference_list_id-${local.name_suffix}"
 description = "referencelist-description"
 entries {
  value = "referencelist-entry-value"
 }
 syntax_type = "REFERENCE_LIST_SYNTAX_TYPE_PLAIN_TEXT_STRING"
}
