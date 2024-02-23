resource "google_vpc_access_connector" "connector" {
  name = "vpc-con-${local.name_suffix}"
  subnet {
    name       = google_compute_subnetwork.custom_test.name
    project_id = "host-project-id"
  }
  machine_type = "e2-standard-4"
}

data "google_compute_subnetwork" "custom_test" {
  name    = "vpc-con-${local.name_suffix}"
  project = "host-project-id"
  region  = var.region
}
