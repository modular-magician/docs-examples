resource "google_project" "default" {
  project_id = "my-project-2-${local.name_suffix}"
  name       = "my-project-2-${local.name_suffix}"
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
  autodelete_anonymous_users = false
  sign_in {
    allow_duplicate_emails = false
   
    anonymous {
        enabled = false
    }
    email {
        enabled = false
    }
    phone_number {
        enabled = false
    }
  }
  blocking_functions {
    triggers {
      event_type   = "beforeSignIn"
      function_uri = "https://us-east1-my-project-2-${local.name_suffix}.cloudfunctions.net/before-sign-in"
    }
    forward_inbound_credentials {
      refresh_token = false
      access_token  = false
      id_token      = false
    }
  }
  client {
    permissions {
      disabled_user_signup = false
      disabled_user_deletion = false
    }
  }
  multi_tenant {
    allow_tenants = false
  }
  monitoring {
    request_logging {
      enabled = false
    }
  }
}
