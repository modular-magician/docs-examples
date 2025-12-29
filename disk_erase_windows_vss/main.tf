data "google_compute_image" "my_image" {
  family  = "windows-2022"
  project = "windows-cloud"
}

resource "google_compute_disk" "source" {
  name  = "test-disk-vss-source-${local.name_suffix}"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  image = data.google_compute_image.my_image.self_link
  physical_block_size_bytes = 4096
}

resource "google_compute_snapshot" "snapshot" {
  name        = "test-snapshot-vss-${local.name_suffix}"
  source_disk = google_compute_disk.source.id
  zone        = "us-central1-a"
}

resource "google_compute_disk" "default" {
  name     = "test-disk-vss-${local.name_suffix}"
  type     = "pd-ssd"
  zone     = "us-central1-a"
  snapshot = google_compute_snapshot.snapshot.id

  erase_windows_vss_signature = true

  physical_block_size_bytes = 4096
}
