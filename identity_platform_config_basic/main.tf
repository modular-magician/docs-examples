resource "google_project" "default" {
  project_id = "my-project-${local.name_suffix}"
  name       = "my-project-${local.name_suffix}"
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
  autodelete_anonymous_users = true
  sign_in {
    allow_duplicate_emails = true
   
    anonymous {
        enabled = true
    }
    email {
        enabled = true
        password_required = false
    }
    phone_number {
        enabled = true
        test_phone_numbers = {
            "+11231231234" = "000000"
        }
    }
  }
  sms_region_config {
    allowlist_only {
      allowed_regions = [
        "US",
        "CA",
      ]
    }
  }
  blocking_functions {
    triggers {
      event_type = "beforeSignIn"
      function_uri = "https://us-east1-my-project-${local.name_suffix}.cloudfunctions.net/before-sign-in"
    }
    forward_inbound_credentials {
      refresh_token = true
      access_token = true
      id_token = true
    }
  }
  quota {
    sign_up_quota_config {
      quota = 1000
      start_time = "2014-10-02T15:01:23Z-${local.name_suffix}"
      quota_duration = "7200s"
    }
  }
  authorized_domains = [
    "localhost",
    "my-project-${local.name_suffix}.firebaseapp.com",
    "my-project-${local.name_suffix}.web.app",
  ]
}
