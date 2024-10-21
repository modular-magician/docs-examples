resource "google_dataproc_gdc_service_instance" "service-instance" {
  service_instance_id = "tf-e2e-service-instance-basic-${local.name_suffix}"
  location        = "us-west2"
  gdce_cluster {
      gdce_cluster = "projects/gdce-cluster-monitoring/locations/us-west2/clusters/gdce-prism-prober-ord106"
  }
}
