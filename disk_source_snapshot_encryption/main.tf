data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_disk" "source" {
  name  = "test-disk-enc-source-${local.name_suffix}"
  image = data.google_compute_image.my_image.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"

  disk_encryption_key {
    raw_key = "SGVsbG9Xb3JsZEhlbGxvV29ybGRIZWxsb1dvcmxkMTI="
  }
}

resource "google_compute_snapshot" "encrypted_snapshot" {
  name        = "test-encrypted-snapshot-${local.name_suffix}"
  source_disk = google_compute_disk.source.self_link
  zone        = "us-central1-a"
  snapshot_encryption_key {
    raw_key = "SGVsbG9Xb3JsZEhlbGxvV29ybGRIZWxsb1dvcmxkMTI="
  }
  source_disk_encryption_key {
    raw_key = "SGVsbG9Xb3JsZEhlbGxvV29ybGRIZWxsb1dvcmxkMTI="
  }
}

resource "google_compute_disk" "default" {
  name     = "test-disk-from-enc-snap-${local.name_suffix}"
  type     = "pd-ssd"
  zone     = "us-central1-a"
  snapshot = google_compute_snapshot.encrypted_snapshot.self_link

  source_snapshot_encryption_key {
    raw_key = "SGVsbG9Xb3JsZEhlbGxvV29ybGRIZWxsb1dvcmxkMTI="
  }
}
