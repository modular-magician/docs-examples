resource "google_clouddeploy_delivery_pipeline" "default" {
  name        = "dp-name-${local.name_suffix}"
  description = "My cloud deploy delivery pipeline"
  location = "us-west1"

  labels        = {
    label1 = "labelvalue1"
  }

  annotations   = {
    annotation1 = "annotation1 value"
  }

  serial_pipeline = {
    stages = {
      profiles = [
        "stg1-profile1",
        "stg1-profile2",
      ]
      strategy = {
        standard = {
          verify = "false"
        }
      }
      targetId = "stg1-targetid"
    }

    stages = {
      profiles = [
        "stg2-profile1",
        "stg2-profile2",
      ]
      strategy = {
        standard = {
          verify = "false"
        }
      }
      targetId = "stg2-targetid"
    }
  }
}

resource "google_clouddeploy_delivery_pipeline_iam_member" "member" {
  location = google_clouddeploy_delivery_pipeline.default.location
  project = google_clouddeploy_delivery_pipeline.default.project
  delivery_pipeline = google_clouddeploy_delivery_pipeline.default.name
  role = "roles/viewer"
  member = "user:jane@example.com"
}

resource "google_clouddeploy_delivery_pipeline_iam_binding" "binding" {
  location = google_clouddeploy_delivery_pipeline.default.location
  project = google_clouddeploy_delivery_pipeline.default.project
  delivery_pipeline = google_clouddeploy_delivery_pipeline.default.name
  role = "roles/viewer"
  members = [
    "user:jane@example.com",
  ]
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/viewer"
    members = [
      "user:jane@example.com",
    ]
  }
}
