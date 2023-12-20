resource "google_vertex_ai_feature_online_store" "featureonlinestore" {
  name = "tf_test_featureonlinestore12"
  labels = {
    foo = "bar"
  }
  region = "us-central1"
  bigtable {
    auto_scaling {
      min_node_count         = 1
      max_node_count         = 2
      cpu_utilization_target = 80
    }
  }
}

resource "google_bigquery_dataset" "tf-test-dataset" {

  dataset_id    = "tf_test_dataset1_featureview1"
  friendly_name = "test"
  description   = "This is a test description"
  location      = "US"
}

resource "google_bigquery_table" "tf-test-table" {
  deletion_protection = false

  dataset_id = google_bigquery_dataset.tf-test-dataset.dataset_id
  table_id   = "tf_test_bq_table"
  schema     = <<EOF
  [
  {
    "name": "entity_id",
    "mode": "NULLABLE",
    "type": "STRING",
    "description": "Test default entity_id"
  },
    {
    "name": "test_entity_column",
    "mode": "NULLABLE",
    "type": "STRING",
    "description": "test secondary entity column"
  },
  {
    "name": "feature_timestamp",
    "mode": "NULLABLE",
    "type": "TIMESTAMP",
    "description": "Default timestamp value"
  }
]
EOF
}

resource "google_vertex_ai_feature_onlinestore_featureview" "featureview" {
  name                 = "tf_test_fv1-${local.name_suffix}"
  feature_online_store = google_vertex_ai_feature_online_store.featureonlinestore.id
  sync_config {
    cron = "0 0 * * *"
  }
  big_query_source {
    uri               = "bq://${google_bigquery_table.tf-test-table.project}.${google_bigquery_table.tf-test-table.dataset_id}.${google_bigquery_table.tf-test-table.table_id}"
    entity_id_columns = ["test_entity_column"]

  }
}

data "google_project" "project" {
  provider = google
}
