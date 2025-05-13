resource "google_firebase_app_hosting_default_domain" "example" {
  project   = google_firebase_app_hosting_backend.example.project
  location  = google_firebase_app_hosting_backend.example.location
  backend   = google_firebase_app_hosting_backend.example.backend_id
  domain_id = google_firebase_app_hosting_backend.example.uri
}

resource "google_firebase_app_hosting_backend" "example" {
  project          = "PROJECT_NAME"

  # Choose the region closest to your users
  location         = "us-central1"
  backend_id       = "dd-mini-${local.name_suffix}"
  app_id           = "1:0000000000:web:674cde32020e16fbce9dbd"
  serving_locality = "GLOBAL_ACCESS"
  service_account  = google_service_account.service_account.email
}

resource "google_service_account" "service_account" {
  project = "PROJECT_NAME"

  # Must be firebase-app-hosting-compute
  account_id                   = ""
  display_name                 = "Firebase App Hosting compute service account"

  # Do not throw if already exists
  create_ignore_already_exists = true
}
