resource "google_contact_center_insights_authorized_view_set" "set" {
  authorized_view_set_id = "authorized-view-set-${local.name_suffix}"
  location               = "us-central1"
  display_name           = "My Authorized View Set"
}
