resource "google_eventarc_pipeline" "primary" {
  location    = "us-central1"
  pipeline_id = "some-pipeline-${local.name_suffix}"
  destinations {
    http_endpoint {
      uri = "https://10.77.0.0:80/route"
    }
    network_config {
      network_attachment = "projects/PROJECT_NAME/regions/us-central1/networkAttachments/some-network-attachment-${local.name_suffix}"
    }
  }
}
