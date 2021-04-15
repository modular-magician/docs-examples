data "google_project" "project" {
  provider = google-beta
}

resource "google_essential_contacts_contact" "contact" {
  provider = google-beta
  parent = data.google_project.project.id
  email = "foo@bar.com"
  language_tag = "en-GB"
  notification_category_subscriptions = ["ALL"]
}
