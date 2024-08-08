resource "google_compute_public_advertised_prefix" "advertised" {
  name                = "my-pap-${local.name_suffix}"
  description         = "my description"
  dns_verification_ip = "2001:db8::55"
  ip_cidr_range       = "2001:db8::/40"
  pdp_scope           = "REGIONAL"
}

resource "google_compute_public_delegated_prefix" "pdp" {
  name          = "my-pdp-${local.name_suffix}"
  region        = "us-central1"
  description   = "my description"
  ip_cidr_range = "2001:db8::/48"
  mode          = "EXTERNAL_IPV6_FORWARDING_RULE_CREATION"
  parent_prefix = google_compute_public_advertised_prefix.advertised.id
}
resource "google_compute_forwarding_rule" "default" {
  name                  = "website-forwarding-rule-${local.name_suffix}"
  region                = "us-central1"
  port_range            = 80
  ip_protocol           = "TCP"
  ip_version            = "IPV6"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = "2001:db8::1/96"
  network_tier          = "PREMIUM"
  backend_service       = google_compute_region_backend_service.backend.id
  ip_collection         = google_compute_public_delegated_prefix.pdp.id
}

resource "google_compute_region_backend_service" "backend" {
  name                  = "website-backend-${local.name_suffix}"
  region                = "us-central1"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.hc.id]
}

resource "google_compute_region_health_check" "hc" {
  name               = "check-website-backend-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1
  region             = "us-central1"

  tcp_health_check {
    port = "80"
  }
}
