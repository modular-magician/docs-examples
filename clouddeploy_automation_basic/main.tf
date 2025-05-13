resource "google_clouddeploy_automation" "b-automation" {
  name     = "cd-automation-${local.name_suffix}"
  project = google_clouddeploy_delivery_pipeline.pipeline.project
  location = google_clouddeploy_delivery_pipeline.pipeline.location
  delivery_pipeline = google_clouddeploy_delivery_pipeline.pipeline.name
  service_account = "SERVICE_ACCT"
  selector {
    targets {
      id = "*"
    }
  }
  rules {
    promote_release_rule {
      id = "promote-release"
    }
  }
  rules {
      advance_rollout_rule {
        id                    = "advance-rollout"
      }
    }
  rules {
    repair_rollout_rule {
      id                    = "repair-rollout"
      repair_phases {
      retry  {
                      attempts = "1"
                  }
       }
      repair_phases {
             rollback {}
          }
      }
  }
  rules {
    timed_promote_release_rule {
      id                    = "timed-promote-release"
      schedule              = "0 9 * * 1"
      time_zone              = "America/New_York"
     }
  }
}

resource "google_clouddeploy_delivery_pipeline" "pipeline" {
  name = "cd-pipeline-${local.name_suffix}"
  location = "us-central1"
  serial_pipeline  {
    stages {
      target_id = "test"
      profiles = []
    }
  }
 }
