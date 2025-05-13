resource "google_eventarc_channel" "primary" {
  location             = "us-central1"
  name                 = "some-channel-${local.name_suffix}"
  crypto_key_name      = "some-key-${local.name_suffix}"
  third_party_provider = "projects/PROJECT_NAME/locations/us-central1/providers/datadog"
}
