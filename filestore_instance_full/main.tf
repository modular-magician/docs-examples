resource "google_filestore_instance" "instance" {
  name = "test-instance-${local.name_suffix}"
  zone = "us-central1-b"
  tier = "BASIC_SSD"

  file_shares {
    capacity_gb = 2660
    name        = "share1"

    nfs_export_options {
      ip_ranges = ["10.0.0.0/24"]
      access_mode = "READ_WRITE"
      squash_mode = "NO_ROOT_SQUASH"
   }

   nfs_export_options {
      ip_ranges = ["10.10.0.0/24"]
      access_mode = "READ_ONLY"
      squash_mode = "ROOT_SQUASH"
      anon_uid = 123
      anon_gid = 456
   }
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}
