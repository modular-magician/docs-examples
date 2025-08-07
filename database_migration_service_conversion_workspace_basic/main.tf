resource "google_database_migration_service_conversion_workspace" "example" {
  location = "us-central1"
  conversion_workspace_id = "my-conversion-workspace-${local.name_suffix}"
  display_name = "Basic conversion workspace"
  
  source {
    engine = "ORACLE"
    version = "21c"
  }
  
  destination {
    engine = "POSTGRESQL"
    version = "15"
  }
}
