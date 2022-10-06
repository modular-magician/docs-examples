resource "google_vertex_ai_model" "model" {
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
  location     = "us-central1"
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
  depends_on   = [
    google_kms_crypto_key_iam_member.crypto_key
  ]
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = "kms-name-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform.iam.gserviceaccount.com"
}

data "google_project" "project" {}
