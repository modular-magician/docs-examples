resource "google_vertex_ai_index_endpoint" "index_endpoint" {
  display_name = "sample-endpoint"
  description  = "A sample vertex endpoint with an public endpoint"
  region       = "us-central1"
  labels       = {
    label-one = "value-one"
  }

  public_endpoint_enabled = true
}
