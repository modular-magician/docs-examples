resource "google_vertex_ai_models" "upload_model" {
  display_name = "test-model-upload-container-spec-${local.name_suffix}"
  region       = "us-central1"
  artifact_uri = "gs://cloud-samples-data/vertex-ai/google-cloud-aiplatform-ci-artifacts/models/iris_xgboost/"
  description  = "A sample model"
  labels = {
    label-one = "value-one"
  }

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
}
