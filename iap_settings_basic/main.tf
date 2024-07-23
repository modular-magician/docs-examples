resource "google_compute_region_backend_service" "default" {
  name                            = "backend-service"
  region                          = "us-central1"
  health_checks                   = [google_compute_health_check.default.id]
  connection_draining_timeout_sec = 10
  session_affinity                = "CLIENT_IP"
}

resource "google_compute_health_check" "default" {
  name               = "rbs-health-check"
  check_interval_sec = 1
  timeout_sec        = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_iap_settings" "default" {
  name = "projects/test_project_id/iap_web/compute-us-central1/services/${google_compute_region_backend_service.default.name}"
  access_settings {
    identity_sources = ["IDENTITY_SOURCE_UPSPECIFIED"]
    cors_settings {
      allow_http_options = true
    }
    reauth_settings {
      method = "LOGIN"
      max_age = "405s"
      policy_type = "MINIMUM"
    }
    allowed_domains_settings {
      domains = ["xyz.org","abc.in"]
      enable = true
    }
  }
  application_settings {
    csm_settings {
      rctoken_aud = "audience"
    } 
    access_denied_page_settings {
      access_denied_page_uri = "access-denied-uri"
      generate_troubleshooting_uri = true
      remediation_token_generation_enabled = true
    }   
  }
}
