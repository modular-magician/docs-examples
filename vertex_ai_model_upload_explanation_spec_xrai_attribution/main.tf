resource "google_vertex_ai_models" "xraiAttributionModel" { // xrai_attribution
  display_name = "test-model-upload-explanation-spec-xrai-attribution-${local.name_suffix}"
  artifact_uri = "gs://cloud-samples-data/vertex-ai/google-cloud-aiplatform-ci-artifacts/models/iris_xgboost/"
  description  = "sample description"

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
      top_k = 1
      xrai_attribution {
        blur_baseline_config {
          max_blur_sigma = 1
        }
        smooth_grad_config {
          feature_noise_sigma {
            noise_sigma {
              name  = "test"
              sigma = 1
            }
          }
          noise_sigma        = 1
          noisy_sample_count = 1
        }
        step_count = 1
      }
    }
  }

  region       = "us-central1"
}
