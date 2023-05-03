resource "google_vertex_ai_model" "model" {
  name = "model-name-${local.name_suffix}"
  container_spec {
    image_uri = "us-docker.pkg.dev/vertex-ai/prediction/xgboost-cpu.1-5:latest"
    args      = ["sample", "args"]
    command   = ["sample", "command"]
    env {
      name  = "env_one"
      value = "value_one"
    }
    health_route = "/health"
    ports {
      container_port = 8080
    }
    predict_route = "/predict"
  }
  display_name = "sample-model"
  region       = "us-central1"
  artifact_uri = "gs://cloud-samples-data/vertex-ai/google-cloud-aiplatform-ci-artifacts/models/iris_xgboost/"
  description  = "A sample model"
  labels = {
    label-one = "value-one"
  }
  version_aliases     = ["default", "v1", "v2"]
  version_description = "A sample model version"
  encryption_spec {
    kms_key_name = "kms-name-${local.name_suffix}"
  }
}
