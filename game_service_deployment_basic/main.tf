resource "google_game_services_game_server_deployment" "default" {
  provider = google-beta

  deployment_id  = "tf-test-deployment-${local.name_suffix}"
  description = "a deployment description"
}
