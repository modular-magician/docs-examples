resource "google_notebooks_instance" "instance" {
  provider = google-beta
  name = "notebooks-instance-${local.name_suffix}"
  location = "us-west1-a"
  machine_type = "n1-standard-1"
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-latest-cpu"
  }
}
