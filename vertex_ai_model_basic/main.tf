resource "google_vertex_ai_models" "model" {
  display_name = "test-model-${local.name_suffix}"
  description  = "sample description"
  labels       = {
    "key1" : "value1",
    "key2" : "value2"
  }

  // encryption_spec {
  //   kms_key_name = "kms-name-${local.name_suffix}"
  // }
  region       = "us-central1"
}
