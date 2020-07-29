resource "google_spanner_instance" "main" {
  config       = "regional-europe-west1"
  display_name = "main-instance"
}

resource "google_spanner_database" "database" {
  instance = google_spanner_instance.main.name
  name     = "my-database-${local.name_suffix}"
}
