resource "google_project" "default" {
  project_id = "my-project-1-${local.name_suffix}"
  name       = "my-project-1-${local.name_suffix}"
  org_id     = "ORG_ID"
  billing_account =  "BILLING_ACCT"
  deletion_policy = "DELETE"
  labels = {
    firebase = "enabled"
  }
}

resource "google_project_service" "identitytoolkit" {
  project = google_project.default.project_id
  service = "identitytoolkit.googleapis.com"
}


resource "google_identity_platform_config" "default" {
  project = google_project.default.project_id
  client {
    permissions {
      disabled_user_deletion = false
      disabled_user_signup   = true
    }
  }

  mfa {
    enabled_providers = ["PHONE_SMS"]
    provider_configs {
      state = "ENABLED"
      totp_provider_config {
        adjacent_intervals = 3
      }
    }
    state = "ENABLED"
  }
  monitoring {
    request_logging {
      enabled = true
    }
  }
  multi_tenant {
    allow_tenants           = true
    default_tenant_location = "organizations/ORG_ID"
  }

  depends_on = [
    google_project_service.identitytoolkit
  ]
}
