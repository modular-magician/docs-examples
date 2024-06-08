resource "google_vertex_ai_models" "sampledShapelyModel" { // sampled_shapley_attribution
  display_name = "test-model-upload-explanation-spec-sampled-shapely-${local.name_suffix}"
  artifact_uri = "gs://cloud-samples-data/vertex-ai/google-cloud-aiplatform-ci-artifacts/models/iris_xgboost/"
  description  = "sample description"

  container_spec {
    image_uri = "us-docker.pkg.dev/vertex-ai/prediction/xgboost-cpu.1-5:latest"
    args      = ["sample", "args"]
    command   = ["sample", "command"]
    deployment_timeout = "60s"
    shared_memory_size_mb = 10
    env {
      name  = "env_one"
      value = "value_one"
    }
    grpc_ports {
      container_port = 8080
    }
    health_probe {
      exec {
        command = ["pwd"]
      }
      period_seconds  = 30
      timeout_seconds = 1
    }
    health_route = "/health"
    ports {
      container_port = 8080
    }
    predict_route = "/predict"
    startup_probe {
      exec {
        command = ["pwd"]
      }
      period_seconds  = 30
      timeout_seconds = 1
    }
  }

  explanation_spec {
    metadata {
      inputs {
        dense_shape_tensor_name = "test"
        encoded_baselines       = [1]
        encoded_tensor_name     = "test"
        encoding                = "IDENTITY"
        feature_value_domain {
          max_value       = 1
          min_value       = 1
          original_mean   = 1
          original_stddev = 1
        }
        group_name            = "test"
        index_feature_mapping = ["test"]
        indices_tensor_name   = "test"
        input_tensor_name     = "test"
        modality              = "numeric"
        name                  = "test"
        visualization {
          clip_percent_lowerbound = 1
          clip_percent_upperbound = 1
          color_map               = "PINK_GREEN"
          overlay_type            = "GRAYSCALE"
          polarity                = "POSITIVE"
          type                    = "PIXELS"
        }
      }
      latent_space_source = "test"
      outputs {
        display_name_mapping_key   = "test"
        name                       = "test"
        output_tensor_name         = "test"
      }
    }
    parameters {
      output_indices = [1]
      sampled_shapley_attribution {
        path_count = 1
      }
      top_k = 1
    }
  }

  region       = "us-central1"
}
