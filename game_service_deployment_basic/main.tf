resource "google_game_services_game_server_deployment" "default" {
  provider = google-private

  deployment_id  = "tf-test-deployment-${local.name_suffix}"
  description = "a deployment description"
}
