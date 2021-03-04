resource "google_healthcare_dataset" "dataset" {
  provider = google-beta

  location = "us-central1"
  name     = "my-dataset-${local.name_suffix}"
}

resource "google_healthcare_consent_store" "my-consent" {
  provider = google-beta

  dataset = google_healthcare_dataset.dataset.id
  name    = "my-consent-store-${local.name_suffix}"
}

resource "google_service_account" "test-account" {
  provider = google-beta

  account_id   = "my-account-${local.name_suffix}"
  display_name = "Test Service Account"
}

resource "google_healthcare_consent_store_iam_member" "test-iam" {
  provider = google-beta

  dataset          = google_healthcare_dataset.dataset.id
  consent_store_id = google_healthcare_consent_store.my-consent.name
  role             = "roles/editor"
  member           = "serviceAccount:${google_service_account.test-account.email}"
}
