resource "google_secure_source_manager_instance" "default" {
    provider = "google-beta"
    instance_id = "instance1-${local.name_suffix}"
    location = "us-central1"
}
