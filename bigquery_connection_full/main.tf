resource "google_sql_database_instance" "instance" {
    provider         = google-beta
    name             = "my-database-instance-${local.name_suffix}"
    database_version = "POSTGRES_11"
    region           = "us-central1"
    settings {
		tier = "db-f1-micro"
	}
}

resource "google_sql_database" "db" {
    provider = google-beta
    instance = google_sql_database_instance.instance.name
    name     = "db"
}

resource "google_bigquery_connection" "connection" {
    provider      = google-beta
    connection_id = "my-connection-${local.name_suffix}"
    location      = "US"
    friendly_name = "👋"
    description   = "a riveting description"
    cloud_sql {
        instance_id = google_sql_database_instance.instance.connection_name
        database    = google_sql_database.db.name
        type        = "POSTGRES"
    }
}
