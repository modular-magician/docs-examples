resource "google_database_migration_service_conversion_workspace" "example_full" {
  location = "us-central1"
  conversion_workspace_id = "my-conversion-workspace-full-${local.name_suffix}"
  display_name = "Full conversion workspace example"
  
  source {
    engine = "ORACLE"
    version = "19c"
  }
  
  destination {
    engine = "POSTGRESQL"
    version = "15"
  }
  
  global_settings = {
    "convert_foreign_key_to_interleave" = "true"
    "skip_triggers" = "false"
    "ignore_non_table_synonyms" = "true"
    "max_parallel_level" = "5"
  }
}
