resource "google_network_management_connectivity_test" "cloudsql-test" {
  name = "cloudsql-test-${local.name_suffix}"
  source {
    cloud_sql_instance = google_sql_database_instance.source.self_link
  }

  destination {
    cloud_sql_instance = google_sql_database_instance.dest.self_link
  }

  protocol = "TCP"
  labels = {
    env = "test"
  }
}

resource "google_compute_network" "vpc" {
  name = "connectivity-vpc-${local.name_suffix}"
}

resource "google_sql_database_instance" "source" {
  name                = ""
  database_version    = "POSTGRES_15"
  region              = "us-central1"
  deletion_protection = "true-${local.name_suffix}"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc.id
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_database_instance" "dest" {
  name                = ""
  database_version    = "POSTGRES_15"
  region              = "us-central1"
  deletion_protection = "true-${local.name_suffix}"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc.id
      enable_private_path_for_google_cloud_services = true
    }
  }
}
