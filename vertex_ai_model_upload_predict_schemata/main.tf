resource "google_vertex_ai_models" "upload_model" {
  display_name = "test-model-upload-predict-schemata-${local.name_suffix}"
  description  = "basic upload model"

  predict_schemata {
    instance_schema_uri   = "gs://cloud-ai-platform-d357fffa-aab0-409b-8e4e-3af03de82d76/instance_schemas/job-5547038670390820864/analysis"
    parameters_schema_uri = "gs://cloud-ai-platform-d357fffa-aab0-409b-8e4e-3af03de82d76/instance_schemas/job-5547038670390820864/analysis"
    prediction_schema_uri = "gs://cloud-ai-platform-d357fffa-aab0-409b-8e4e-3af03de82d76/instance_schemas/job-5547038670390820864/analysis"
  }

  metadata {
    config {
      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count    = 1
          leaf_nodes_to_search_percent = 1
        }
      }
      approximate_neighbors_count = 1
      dimensions                  = 1
      distance_measure_type       = 1
      feature_norm_type           = "normal"
      shard_size                  = 1
    }
    contents_delta_uri    = "test"
    is_complete_overwrite = false
  }

  labels       = {
    "key1" : "value1",
    "key2" : "value2"
  }
  region       = "us-central1"
}
