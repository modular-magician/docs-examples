data "google_project" "project" {
  provider = google-beta
}

resource "google_container_cluster" "primary" {
  name               = "basiccluster-${local.name_suffix}"
  location           = "us-central1-a"
  initial_node_count = 1
  provider = google-beta
}

resource "google_gke_hub_membership" "membership" {
  membership_id = "basic-${local.name_suffix}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.primary.id}"
    }
  }
  description = "test resource."
  provider = google-beta
}

resource "google_gke_hub_feature" "feature" {
  feature_id = "configmanagement"
  membership_specs {
    membership_id = "projects/${data.google_project.project.number}/locations/global/memberships/${google_gke_hub_membership.membership.membership_id}"
    configmanagement {
      version = "1.6.2"
      config_sync {
        source_format = "hierarchy"
        git {
          sync_repo = "https://github.com/GoogleCloudPlatform/magic-modules"
        }
      }
    }
  }
  provider = google-beta
}
