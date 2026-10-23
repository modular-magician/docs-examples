resource "google_oracle_database_odb_dns_zone" "my-odb-dns-zone"{
  odb_dns_zone_id = "my-odb-dns-zone-${local.name_suffix}"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  odbnetwork = google_oracle_database_odb_network.my-odbnetwork.odb_network_id
  domain = "abc.example.com.-${local.name_suffix}"
  labels = {
    terraform_created = "true"
  }
  deletion_protection = "true-${local.name_suffix}"
}

resource "google_oracle_database_odb_network" "my-odbnetwork"{
  odb_network_id = "my-odbnetwork-${local.name_suffix}"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  network = data.google_compute_network.default.id
  labels = {
    terraform_created = "true"
  }
  deletion_protection = "true-${local.name_suffix}"
}

data "google_compute_network" "default" {
  name     = "default"
  project = "my-project-${local.name_suffix}"
}
