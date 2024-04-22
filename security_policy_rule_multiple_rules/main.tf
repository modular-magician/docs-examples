resource "google_compute_security_policy" "default" {
  name        = "policywithmultiplerules-${local.name_suffix}"
  description = "basic global security policy"
  type        = "CLOUD_ARMOR"
}

resource "google_compute_security_policy_rule" "policy_rule_one" {
  security_policy = google_compute_security_policy.default.name
  description     = "new rule one"
  priority        = 100
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["10.10.0.0/16"]
    }
  }
  action          = "allow"
  preview         = true
}

resource "google_compute_security_policy_rule" "policy_rule_two" {
  security_policy = google_compute_security_policy.default.name
  description     = "new rule two"
  priority        = 101
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["192.168.0.0/16", "10.0.0.0/8"]
    }
  }
  action          = "allow"
  preview         = true
}
