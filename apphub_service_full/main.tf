resource "google_apphub_application" "application" {
  location = "us-central1"
  application_id = "example-application-1-${local.name_suffix}"
  scope {
    type = "REGIONAL"
  }
}

resource "google_project" "service_project" {
  project_id ="project-1-${local.name_suffix}"
  name = "Service Project"
  org_id = "ORG_ID"
  billing_account = "BILLING_ACCT"
  deletion_policy = "DELETE"
}

# Enable Compute API
resource "google_project_service" "compute_service_project" {
  project = google_project.service_project.project_id
  service = "compute.googleapis.com"
}

resource "time_sleep" "wait_120s" {
  depends_on = [google_project_service.compute_service_project]

  create_duration = "120s"
}

resource "google_apphub_service_project_attachment" "service_project_attachment" {
  service_project_attachment_id = google_project.service_project.project_id
  depends_on = [time_sleep.wait_120s]
}

# discovered service block
data "google_apphub_discovered_service" "catalog-service" {
  provider = google
  location = "us-central1"
  service_uri = "//compute.googleapis.com/${google_compute_forwarding_rule.forwarding_rule.id}"
  depends_on = [google_apphub_service_project_attachment.service_project_attachment, time_sleep.wait_120s_for_resource_ingestion]
}

resource "time_sleep" "wait_120s_for_resource_ingestion" {
  depends_on = [google_compute_forwarding_rule.forwarding_rule]
  create_duration = "120s"
}

resource "google_apphub_service" "example" {
  location = "us-central1"
  application_id = google_apphub_application.application.application_id
  service_id = google_compute_forwarding_rule.forwarding_rule.name
  discovered_service = data.google_apphub_discovered_service.catalog-service.name
  display_name = "Example Service Full-${local.name_suffix}"
  description = "Register service for testing-${local.name_suffix}"
  attributes {
    environment {
      type = "STAGING"
    }
    criticality {  
        type = "MISSION_CRITICAL"
    }
    business_owners {
        display_name =  "Alice-${local.name_suffix}"
        email        =  "alice@google.com-${local.name_suffix}"
    }
    developer_owners {
        display_name =  "Bob-${local.name_suffix}"
        email        =  "bob@google.com-${local.name_suffix}"
    }
    operator_owners {
        display_name =  "Charlie-${local.name_suffix}"
        email        =  "charlie@google.com-${local.name_suffix}"
    }
  }
}


#creates service


# VPC network
resource "google_compute_network" "ilb_network" {
  name                    = "l7-ilb-network-${local.name_suffix}"
  project                 = google_project.service_project.project_id
  auto_create_subnetworks = false
  depends_on = [time_sleep.wait_120s]
}


# backend subnet
resource "google_compute_subnetwork" "ilb_subnet" {
  name          = "l7-ilb-subnet-${local.name_suffix}"
  project       = google_project.service_project.project_id
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.ilb_network.id
}

# forwarding rule
resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  ="l7-ilb-forwarding-rule-${local.name_suffix}"
  project               = google_project.service_project.project_id
  region                = "us-central1"
  ip_version            = "IPV4"
  load_balancing_scheme = "INTERNAL"
  all_ports             = true
  backend_service       = google_compute_region_backend_service.backend.id
  network               = google_compute_network.ilb_network.id
  subnetwork            = google_compute_subnetwork.ilb_subnet.id
}



# backend service
resource "google_compute_region_backend_service" "backend" {
  name                  = "l7-ilb-backend-subnet-${local.name_suffix}"
  project               = google_project.service_project.project_id
  region                = "us-central1"
  health_checks         = [google_compute_health_check.default.id]
}

# health check
resource "google_compute_health_check" "default" {
  name     = "l7-ilb-hc-${local.name_suffix}"
  project  = google_project.service_project.project_id
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
  depends_on = [time_sleep.wait_120s]
}
