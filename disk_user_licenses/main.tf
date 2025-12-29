resource "google_compute_disk" "default" {
  name  = "test-disk-user-licenses-${local.name_suffix}"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  size  = 10

  user_licenses = [
    "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/licenses/debian-9-stretch"
  ]

  physical_block_size_bytes = 4096
}
