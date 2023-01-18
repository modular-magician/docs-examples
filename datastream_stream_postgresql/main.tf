resource "google_datastream_connection_profile" "source" {
    display_name          = "Postgresql Source"
    location              = "us-central1"
    connection_profile_id = "source-profile-${local.name_suffix}"

    postgresql_profile {
        hostname = "hostname"
        port     = 3306
        username = "user"
        password = "pass"
        database = "postgres"
    }
}

resource "google_datastream_connection_profile" "destination" {
    display_name          = "BigQuery Destination"
    location              = "us-central1"
    connection_profile_id = "destination-profile-${local.name_suffix}"

    bigquery_profile {}
}

resource "google_datastream_stream" "default"  {
    display_name = "Postgres to BigQuery"
    location     = "us-central1"
    stream_id    = "my-stream-${local.name_suffix}"
    desired_state = "RUNNING"

    source_config {
        source_connection_profile = google_datastream_connection_profile.source.id
        postgresql_source_config {
            max_concurrent_backfill_tasks = 12
            publication      = "publication"
            replication_slot = "replication_slot"
            include_objects {
                postgresql_schemas {
                    schema = "schema"
                    postgresql_tables {
                        table = "table"
                        postgresql_columns {
                            column = "column"
                        }
                    }
                }
            }
            exclude_objects {
                postgresql_schemas {
                    schema = "schema"
                    postgresql_tables {
                        table = "table"
                        postgresql_columns {
                            column = "column"
                        }
                    }
                }
            }
        }
    }

    destination_config {
        destination_connection_profile = google_datastream_connection_profile.destination.id
        bigquery_destination_config {
            data_freshness = "900s"
            source_hierarchy_datasets {
                dataset_template {
                   location = "us-central1"
                }
            }
        }
    }

    backfill_all {
        postgresql_excluded_objects {
            postgresql_schemas {
                schema = "schema"
                postgresql_tables {
                    table = "table"
                    postgresql_columns {
                        column = "column"
                    }
                }
            }
        }
    }
}
