resource "google_project" "owner_project" {
  project_id      = "tf-test%{random_suffix}"
  name            = "tf-test%{random_suffix}"
  org_id          = "ORG_ID"
  billing_account = "BILLING_ACCT"
  deletion_policy = "DELETE"
}


resource "google_project_service" "compute" {
  project = google_project.owner_project.project_id
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project" "guest_project" {
  project_id      = "tf-test-2%{random_suffix}"
  name            = "tf-test-2%{random_suffix}"
  org_id          = "ORG_ID"
  deletion_policy = "DELETE"
}

resource "google_organization_policy" "shared_reservation_org_policy" {
  org_id     = "ORG_ID"
  constraint = "constraints/compute.sharedReservationsOwnerProjects"
  list_policy {
    allow {
      values = ["projects/${google_project.owner_project.number}"]
    }
  }
}

resource "google_compute_reservation" "gce_reservation" {
  project = google_project.owner_project.project_id
  name = "gce-shared-reservation-${local.name_suffix}"
  zone = "us-central1-a"

  specific_reservation {
    count = 1
    instance_properties {
      min_cpu_platform = "Intel Cascade Lake"
      machine_type     = "n2-standard-2"
    }
  }
  share_settings {
    share_type = "SPECIFIC_PROJECTS"
    project_map {
      id = google_project.guest_project.project_id
      project_id = google_project.guest_project.project_id
    }
  }
  depends_on = [google_organization_policy.shared_reservation_org_policy,google_project_service.compute]
}
