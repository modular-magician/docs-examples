resource "google_gke_backup_backup_channel" "basic" {
  name = "basic-channel-${local.name_suffix}"
  location = "us-central1"
  description = ""
  destination_project = "projects/24240755850-${local.name_suffix}"
  labels = { "key": "some-value" }
}
