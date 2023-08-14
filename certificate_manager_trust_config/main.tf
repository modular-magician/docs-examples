resource "google_certificate_manager_trust_config" "default" {
  name        = "trust-config-${local.name_suffix}"
  description = "sample description for the trust config"
  location    = "us-central1"

  trust_stores {
    trust_anchors { 
      pem_certificate = file("test-fixtures/certificatemanager/cert.pem")
    }
    intermediate_cas { 
      pem_certificate = file("test-fixtures/certificatemanager/cert.pem")
    }
  }

  labels = {
    foo = "bar"
  }
}
