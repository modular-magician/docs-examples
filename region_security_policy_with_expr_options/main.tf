resource "google_compute_region_security_policy" "region-sec-policy-expr-options" {
  name        = "my-sec-policy-expr-options-${local.name_suffix}"
  region      = "us-central1"
  description = "basic region security policy with expr_options"
  type        = "CLOUD_ARMOR"

  rules {
    action      = "deny(403)"
    priority    = "2000"
    description = "reCAPTCHA rule"
    match {
      expr {
        expression = "request.path.endsWith('RegisterWithEmail') && token.recaptcha_action.score >= 0.8 && (token.recaptcha_action.valid)"
      }
      expr_options {
        recaptcha_options {
          action_token_site_keys  = ["placeholder-recaptcha-action-site-key-01", "placeholder-recaptcha-action-site-key-02"]
          session_token_site_keys = ["placeholder-recaptcha-session-site-key-1", "placeholder-recaptcha-session-site-key-2"]
        }
      }
    }
  }

  rules {
    action      = "allow"
    priority    = "2147483647"
    description = "default rule"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}
