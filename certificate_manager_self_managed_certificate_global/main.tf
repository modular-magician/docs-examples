resource "google_certificate_manager_certificate" "default" {
  name        = "self-managed-cert-${local.name_suffix}"
  description = "Global cert"
  self_managed {
    pem_certificate = file("test-fixtures/certificatemanager/cert.pem")
    pem_private_key = file("test-fixtures/certificatemanager/private-key.pem")
  }
}
