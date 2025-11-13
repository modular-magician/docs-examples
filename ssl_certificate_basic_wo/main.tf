resource "google_compute_ssl_certificate" "default" {
  name_prefix = "my-certificate-"
  description = "a description"
  private_key_wo = file("../static/ssl_cert/test.key")
  private_key_wo_version = 1
  certificate_wo = file("../static/ssl_cert/test.crt")
  certificate_wo_version = 1
  lifecycle {
    create_before_destroy = true
  }
}
