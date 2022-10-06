resource "google_vertex_ai_model_deployment" "model_deployment" {
  dedicated_resources {
    machine_spec {
      machine_type = "n1-standard-2"
    }
    min_replica_count = 1
    max_replica_count = 1
  }
  endpoint = "${google_vertex_ai_endpoint.minimal.name}"
  model    = "${google_vertex_ai_model.minimal.id}"
  location = "us-central1"
}

resource "google_vertex_ai_model" "minimal" {
  container_spec {
    image_uri = "us-docker.pkg.dev/vertex-ai/prediction/xgboost-cpu.1-5:latest"
  }
  display_name = "sample-model"
  location     = "us-central1"
  artifact_uri = "gs://cloud-samples-data/vertex-ai/google-cloud-aiplatform-ci-artifacts/models/iris_xgboost/"
}

resource "google_vertex_ai_endpoint" "minimal" {
  display_name = "sample-endpoint"
  location     = "us-central1"
}
