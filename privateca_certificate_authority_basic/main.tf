resource "google_privateca_certificate_authority" "default" {
  provider = google-beta
  certificate_authority_id = "my-certificate-authority-${local.name_suffix}"
  location = "us-central1"
  config {
    subject_config {
      subject {
        organization = "HashiCorp"
      }
      common_name = "my-certificate-authority"
      subject_alt_name {
        dns_names = ["hashicorp.com"]
      }
    }
    reusable_config {
      reusable_config = "projects/568668481468/locations/us-central1/reusableConfigs/root-unconstrained"
    }
  }
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
}
