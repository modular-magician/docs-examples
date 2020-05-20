resource "google_game_services_game_server_deployment" "default" {
  provider = google-beta

  deployment_id  = "tf-test-deployment-${local.name_suffix}"
  description = "a deployment description"
}

resource "google_game_services_game_server_config" "default" {
  provider = google-beta

  config_id     = "tf-test-config-${local.name_suffix}"
  deployment_id = google_game_services_game_server_deployment.default.deployment_id
  description   = "a config description"

  fleet_configs {
    name       = "some-non-guid"
    fleet_spec = jsonencode({ "replicas" : 1, "scheduling" : "Packed", "template" : { "metadata" : { "name" : "tf-test-game-server-template" }, "spec" : { "template" : { "spec" : { "containers" : [{ "name" : "simple-udp-server", "image" : "gcr.io/agones-images/udp-server:0.14" }] } } } } })

    // Alternate usage:
    // fleet_spec = file(fleet_configs.json)
  }
}

resource "google_game_services_game_server_deployment_rollout" "default" {
  provider = google-beta

  deployment_id              = google_game_services_game_server_deployment.default.deployment_id
  default_game_server_config = google_game_services_game_server_config.default.name
}
