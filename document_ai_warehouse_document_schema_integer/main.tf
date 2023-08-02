resource "google_document_ai_warehouse_document_schema" "example_integer" {
  project_number = data.google_project.project.number
  display_name   = "test-property-integer"
  location       = "us"

  property_definitions {
    name                 = "prop1"
    display_name         = "propdisp1"
    is_repeatable        = false
    is_filterable        = true
    is_searchable        = true
    is_metadata          = false
    is_required          = false
    retrieval_importance = "HIGHEST"
    schema_sources {
      name           = "dummy_source"
      processor_type = "dummy_processor"
    }
    integer_type_options {}
  }
}

data "google_project" "project" {
}
