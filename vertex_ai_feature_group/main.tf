  resource "google_vertex_ai_feature_group" "feature_group" {
  name = "example_feature_group-${local.name_suffix}"
  description = "A sample feature group"
  region = "us-central1"
  labels = {
      label-one = "value-one"
  }
  big_query {
    big_query_source {
        # The source table must have a column named 'feature_timestamp' of type TIMESTAMP.
        input_uri = "bq://${google_bigquery_table.sample_table.project}.${google_bigquery_table.sample_table.dataset_id}.${google_bigquery_table.sample_table.table_id}"
    }
    entity_id_columns = ["feature_id"]
  }
}

resource "google_bigquery_dataset" "sample_dataset" {
  dataset_id                  = "job_load-${local.name_suffix}_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "US"
}

resource "google_bigquery_table" "sample_table" {
  deletion_protection = false
  dataset_id = google_bigquery_dataset.sample_dataset.dataset_id
  table_id   = "job_load-${local.name_suffix}_table"

  schema = <<EOF
[
    {
        "name": "feature_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "feature_timestamp",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    }
]
EOF
}
