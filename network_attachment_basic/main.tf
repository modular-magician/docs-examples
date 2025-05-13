resource "google_compute_network_attachment" "default" {
    name = "basic-network-attachment-${local.name_suffix}"
    region = "us-central1"
    description = "basic network attachment description"
    connection_preference = "ACCEPT_MANUAL"

    subnetworks = [
        google_compute_subnetwork.default.self_link
    ]

    producer_accept_lists = [
        google_project.accepted_producer_project.project_id
    ]

    producer_reject_lists = [
        google_project.rejected_producer_project.project_id
    ]
}

resource "google_compute_network" "default" {
    name = "basic-network-${local.name_suffix}"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
    name = "basic-subnetwork-${local.name_suffix}"
    region = "us-central1"

    network = google_compute_network.default.id
    ip_cidr_range = "10.0.0.0/16"
}

resource "google_project" "rejected_producer_project" {
    project_id      = "prj-rejected-${local.name_suffix}"
    name            = "prj-rejected-${local.name_suffix}"
    org_id          = "ORG_ID"
    billing_account = "BILLING_ACCT"
    deletion_policy = "DELETE"
}

resource "google_project" "accepted_producer_project" {
    project_id      = "prj-accepted-${local.name_suffix}"
    name            = "prj-accepted-${local.name_suffix}"
    org_id          = "ORG_ID"
    billing_account = "BILLING_ACCT"
    deletion_policy = "DELETE"
}
