resource "google_database_migration_service_connection_profile" "postgresprofile" {
  location              = "us-central1"
  connection_profile_id = "my-profileid-${local.name_suffix}"
  display_name          = "my-profileid-${local.name_suffix}-display"
  labels = {
    foo = "bar"
  }
  postgresql {
    host     = "10.20.30.40"
    port     = 5432
    username = "my-username-${local.name_suffix}"
    password = "my-password-${local.name_suffix}"
    database = "postgres"
    ssl {
      type = "REQUIRED"
      ssl_flags = {
        server_certificate_hostname = "example.com"
      }
    }
  }
}
