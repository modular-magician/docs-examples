resource "google_network_security_security_profile" "default" {
  name        = "my-security-profile-${local.name_suffix}"
  parent      = "organizations/ORG_ID"
  description = "my description"
  type        = "THREAT_PREVENTION"

  threat_prevention_profile {
    severity_overrides {
      action   = "ALLOW"
      severity = "INFORMATIONAL"
    }

    severity_overrides {
      action   = "DENY"
      severity = "HIGH"
    }

    threat_overrides {
      action    = "ALLOW"
      threat_id = "280647"
    }

    antivirus_overrides {
      protocol = "SMTP"
      action   = "ALLOW"
    }
  }
}
