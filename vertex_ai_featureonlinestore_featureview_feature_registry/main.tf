resource "google_vertex_ai_feature_online_store" "featureonlinestore" {
  name     = "example_feature_view_feature_registry-${local.name_suffix}"
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

resource "google_bigquery_dataset" "sample_dataset" {
  dataset_id                  = "example_feature_view_feature_registry-${local.name_suffix}"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "US"
}

resource "google_bigquery_table" "sample_table" {
  deletion_protection = false
  dataset_id = google_bigquery_dataset.sample_dataset.dataset_id
  table_id   = "example_feature_view_feature_registry-${local.name_suffix}"

  schema = <<EOF
[
    {
        "name": "feature_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "example_feature_view_feature_registry-${local.name_suffix}",
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

resource "google_vertex_ai_feature_group" "sample_feature_group" {
  name = "example_feature_view_feature_registry-${local.name_suffix}"
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



resource "google_vertex_ai_feature_group_feature" "sample_feature" {
  name = "example_feature_view_feature_registry-${local.name_suffix}"
  region = "us-central1"
  feature_group = google_vertex_ai_feature_group.sample_feature_group.name
  description = "A sample feature"
  labels = {
      label-one = "value-one"
  }
}


resource "google_vertex_ai_feature_online_store_featureview" "featureview_featureregistry" {
  name                 = "example_feature_view_feature_registry-${local.name_suffix}"
  region               = "us-central1"
  feature_online_store = google_vertex_ai_feature_online_store.featureonlinestore.name
  sync_config {
    cron = "0 0 * * *"
  }
  feature_registry_source {
    
    feature_groups { 
        feature_group_id = google_vertex_ai_feature_group.sample_feature_group.name
        feature_ids      = [google_vertex_ai_feature_group_feature.sample_feature.name]
       }
  }
}
