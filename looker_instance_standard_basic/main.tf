resource "google_looker_instance" "looker-instance" {
  name              = "my-instance-${local.name_suffix}"
  platform_edition  = "LOOKER_CORE_STANDARD"
  region            = "us-central1"
  public_ip_enabled = true
  oauth_config {
    client_id = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }

  user_metadata {
    additional_standard_user_count = 1
    additional_viewer_user_count = 1
    additional_developer_user_count = 1
  }

}
