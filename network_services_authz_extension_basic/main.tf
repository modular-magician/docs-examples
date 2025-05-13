resource "google_compute_region_backend_service" "default" {
  name                  = "authz-service-${local.name_suffix}"
  project               = "PROJECT_NAME"
  region                = "us-west1"

  protocol              = "HTTP2"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_name             = "grpc"
}

resource "google_network_services_authz_extension" "default" {
  name     = "my-authz-ext-${local.name_suffix}"
  project  = "PROJECT_NAME"
  location = "us-west1"

  description           = "my description"
  load_balancing_scheme = "INTERNAL_MANAGED"
  authority             = "ext11.com"
  service               = google_compute_region_backend_service.default.self_link
  timeout               = "0.1s"
  fail_open             = false
  forward_headers       = ["Authorization"]
}
