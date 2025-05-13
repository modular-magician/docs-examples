resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone-${local.name_suffix}"
  dns_name    = "multiproject.private.example.com."
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network_1_project_1.id
    }
    networks {
      network_url = google_compute_network.network_2_project_1.id
    }
    networks {
      network_url = google_compute_network.network_1_project_2.id
    }
    networks {
      network_url = google_compute_network.network_2_project_2.id
    }
  }

  depends_on = [
    google_project_service.compute_project_1,
    google_project_service.dns_project_1,
    google_project_service.compute_project_2,
    google_project_service.dns_project_2,
  ]
}

resource "google_project" "project_1" {
  name            = "project-1-${local.name_suffix}"
  project_id      = "project-1-${local.name_suffix}"
  org_id          = "ORG_ID"
  billing_account = "BILLING_ACCT"
  deletion_policy = "DELETE"
}

resource "google_project" "project_2" {
  name            = "project-2-${local.name_suffix}"
  project_id      = "project-2-${local.name_suffix}"
  org_id          = "ORG_ID"
  billing_account = "BILLING_ACCT"
  deletion_policy = "DELETE"
}

resource "google_compute_network" "network_1_project_1" {
  name                    = "network-1-${local.name_suffix}"
  project                 = google_project.project_1.project_id
  auto_create_subnetworks = false
  depends_on              = [ 
    google_project_service.compute_project_1,
    google_project_service.dns_project_1,
  ]
}

resource "google_compute_network" "network_2_project_1" {
  name                    = "network-2-${local.name_suffix}"
  project                 = google_project.project_1.project_id
  auto_create_subnetworks = false
  depends_on              = [ 
    google_project_service.compute_project_1,
    google_project_service.dns_project_1,
  ]
}

resource "google_compute_network" "network_1_project_2" {
  name                    = "network-1-${local.name_suffix}"
  project                 = google_project.project_2.project_id
  auto_create_subnetworks = false
  depends_on              = [ 
    google_project_service.compute_project_2,
    google_project_service.dns_project_2,
  ]
}

resource "google_compute_network" "network_2_project_2" {
  name                    = "network-2-${local.name_suffix}"
  project                 = google_project.project_2.project_id
  auto_create_subnetworks = false
  depends_on              = [ 
    google_project_service.compute_project_2,
    google_project_service.dns_project_2,
  ]
}

resource "google_project_service" "compute_project_1" {
  project    = google_project.project_1.project_id
  service    = "compute.googleapis.com"
  depends_on = [
    google_project.project_1,
  ]
}

resource "google_project_service" "compute_project_2" {
  project    = google_project.project_2.project_id
  service    = "compute.googleapis.com"
  depends_on = [
    google_project_service.dns_project_1
  ]
}

resource "google_project_service" "dns_project_1" {
  project    = google_project.project_1.project_id
  service    = "dns.googleapis.com"
  depends_on = [
    google_project_service.compute_project_1
  ]
}

resource "google_project_service" "dns_project_2" {
  project    = google_project.project_2.project_id
  service    = "dns.googleapis.com"
  depends_on = [
    google_project_service.compute_project_2,
  ]
}
