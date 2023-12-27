resource "google_secure_source_manager_instance" "my_instance" {
  location = "us-central1"
  instance_id = "my-instance-${local.name_suffix}"
  labels = {
    "foo" = "bar"
  }
}

resource "google_secure_source_manager_repository" "default" {
  instance = google_secure_source_manager_instance.my_instance.name
  repository_id = "my-repository-${local.name_suffix}"
}
