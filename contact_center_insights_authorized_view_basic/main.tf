resource "google_contact_center_insights_authorized_view_set" "set" {
  authorized_view_set_id = "tf-test-set-authorized-view-${local.name_suffix}"
  location               = "us-central1"
  display_name           = "My Authorized View Set"
}

resource "google_contact_center_insights_authorized_view" "default" {
  authorizedviewset   = google_contact_center_insights_authorized_view_set.set.authorized_view_set_id
  authorized_view_id  = "authorized-view-${local.name_suffix}"
  location            = "us-central1"
  display_name        = "My Authorized View"
  conversation_filter = "agent_id = \"1\""
}
