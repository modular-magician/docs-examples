resource "google_vertex_ai_model" "model" {
  name = "model-name-${local.name_suffix}"
  container_spec {
    image_uri = "gcr.io/cloud-ml-service-public/cloud-ml-online-prediction-model-server-cpu:v1_15py3cmle_op_images_20200229_0210_RC00"
  }
  display_name = "sample-model"
  region       = "us-central1"
}
