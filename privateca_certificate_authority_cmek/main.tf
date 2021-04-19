resource "google_project_service_identity" "privateca_sa" {
  provider = google-beta
  service  = "privateca.googleapis.com"
}

resource "google_kms_crypto_key_iam_binding" "privateca_sa_keyuser_signerverifier" {
  provider      = google-beta
  crypto_key_id = "projects/keys-project/locations/us-central1/keyRings/key-ring/cryptoKeys/crypto-key-${local.name_suffix}"
  role          = "roles/cloudkms.signerVerifier"

  members = [
    "serviceAccount:${google_project_service_identity.privateca_sa.email}",
  ]
}

resource "google_kms_crypto_key_iam_binding" "privateca_sa_keyuser_viewer" {
  provider      = google-beta
  crypto_key_id = "projects/keys-project/locations/us-central1/keyRings/key-ring/cryptoKeys/crypto-key-${local.name_suffix}"
  role          = "roles/viewer"
  members = [
    "serviceAccount:${google_project_service_identity.privateca_sa.email}",
  ]
}

resource "google_privateca_certificate_authority" "default" {
  provider                 = google-beta
  certificate_authority_id = "tf-test%{random_suffix}"
  location                 = "us-central1"

  key_spec {
    cloud_kms_key_version = "projects/keys-project/locations/us-central1/keyRings/key-ring/cryptoKeys/crypto-key-${local.name_suffix}/cryptoKeyVersions/1"
  }

  config  {
    subject_config  {
      common_name = "Example Authority"
      subject {
        organization = "Example, Org."
      }
    }

    reusable_config {
      reusable_config= "root-unconstrained"
    }
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.privateca_sa_keyuser_signerverifier,
    google_kms_crypto_key_iam_binding.privateca_sa_keyuser_viewer,
  ]

  disable_on_delete = true
}
