resource "google_certificate_manager_certificate" "default" {
  name        = "issuance-config-cert-${local.name_suffix}"
  description = "sample google managed all_regions certificate with issuance config for terraform"
  scope       = "ALL_REGIONS" 
  managed {
    domains = [
        "terraform.subdomain1.com"
      ]
    issuance_config = google_certificate_manager_certificate_issuance_config.issuanceconfig.id
  }
}



# creating certificate_issuance_config to use it in the managed certificate
resource "google_certificate_manager_certificate_issuance_config" "issuanceconfig" {
  name    = "issuance-config-${local.name_suffix}"
  description = "sample description for the certificate issuanceConfigs"
  certificate_authority_config {
    certificate_authority_service_config {
        ca_pool = google_privateca_ca_pool.pool.id
    }
  }
  lifetime = "1814400s"
  rotation_window_percentage = 34
  key_algorithm = "ECDSA_P256"
  depends_on=[google_privateca_certificate_authority.ca_authority]
}
  
resource "google_privateca_ca_pool" "pool" {
  name     = "ca-pool-${local.name_suffix}"
  location = "us-central1"
  tier     = "ENTERPRISE"
}

resource "google_privateca_certificate_authority" "ca_authority" {
  location = "us-central1"
  pool = google_privateca_ca_pool.pool.name
  certificate_authority_id = "ca-authority-${local.name_suffix}"
  config {
    subject_config {
      subject {
        organization = "HashiCorp"
        common_name = "my-certificate-authority"
      }
      subject_alt_name {
        dns_names = ["hashicorp.com"]
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }

  // Disable CA deletion related safe checks for easier cleanup.
  deletion_protection                    = false
  skip_grace_period                      = true
  ignore_active_certificates_on_deletion = true
}
