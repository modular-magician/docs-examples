data "google_compute_network" "test_replication" {
  name = "test-network-${local.name_suffix}"
}

resource "google_netapp_storage_pool" "source_pool" {
  name          = "src-pool-zonal-same-${local.name_suffix}"
  location      = "us-central1-a"
  service_level = "FLEX"
  capacity_gib  = 2048
  type          = "UNIFIED"
  network       = data.google_compute_network.test_replication.id
}

resource "google_netapp_storage_pool" "destination_pool" {
  name          = "dst-pool-zonal-same-${local.name_suffix}"
  location      = "us-central1-a"
  service_level = "FLEX"
  type          = "UNIFIED"
  capacity_gib  = 2048
  network       = data.google_compute_network.test_replication.id
}

resource "google_netapp_volume" "source_volume" {
  location     = google_netapp_storage_pool.source_pool.location
  name         = "src_vol_zonal_same-${local.name_suffix}"
  capacity_gib = 100
  share_name   = "src-share-zonal-same-${local.name_suffix}"
  storage_pool = google_netapp_storage_pool.source_pool.name
  protocols = [
    "NFSV3"
  ]
  deletion_policy = "FORCE"
}

resource "google_netapp_volume_replication" "test_replication" {
  depends_on           = [google_netapp_volume.source_volume]
  location             = google_netapp_volume.source_volume.location
  volume_name          = google_netapp_volume.source_volume.name
  name                 = "rep-zonal-same-${local.name_suffix}"
  replication_schedule = "EVERY_10_MINUTES"
  description          = "This is an in-region replication resource (zonal same zone)"
  destination_volume_parameters {
    storage_pool = google_netapp_storage_pool.destination_pool.id
    volume_id    = "dst_vol_zonal_same-${local.name_suffix}"
    share_name   = "dst-share-zonal-same-${local.name_suffix}"
    description  = "This is a replicated volume"
  }
  # WARNING: Setting delete_destination_volume to true, will delete the
  # CURRENT destination volume if the replication is deleted. Omit the field 
  # or set delete_destination_volume=false to avoid accidental volume deletion.
  delete_destination_volume = true
  wait_for_mirror = true
}
