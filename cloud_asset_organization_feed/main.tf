# Create a feed that sends notifications about network resource updates under a
# particular organization.
resource "google_cloud_asset_organization_feed" "organization_feed" {
  billing_project = "PROJECT_NAME"
  org_id          = "ORG_ID"
  feed_id         = "network-updates-${local.name_suffix}"
  content_type    = "RESOURCE"

  asset_types = [
    "compute.googleapis.com/Subnetwork",
    "compute.googleapis.com/Network",
  ]

  feed_output_config {
    pubsub_destination {
      topic = google_pubsub_topic.feed_output.id
    }
  }

  condition {
    expression = <<-EOT
    !temporal_asset.deleted &&
    temporal_asset.prior_asset_state == google.cloud.asset.v1.TemporalAsset.PriorAssetState.DOES_NOT_EXIST
    EOT
    title = "created"
    description = "Send notifications on creation events"
  }
}

# The topic where the resource change notifications will be sent.
resource "google_pubsub_topic" "feed_output" {
  project  = "PROJECT_NAME"
  name     = "network-updates-${local.name_suffix}"
}

# Find the project number of the project whose identity will be used for sending
# the asset change notifications.
data "google_project" "project" {
  project_id = "PROJECT_NAME"
}
