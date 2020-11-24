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
