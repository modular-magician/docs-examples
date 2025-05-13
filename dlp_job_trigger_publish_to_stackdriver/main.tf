resource "google_data_loss_prevention_job_trigger" "publish_to_stackdriver" {
  parent       = "projects/PROJECT_NAME"
  description  = "Description for the job_trigger created by terraform"
  display_name = "TerraformDisplayName"

  triggers {
    schedule {
      recurrence_period_duration = "86400s"
    }
  }

  inspect_job {
    inspect_template_name = "sample-inspect-template"
    actions {
      publish_to_stackdriver {}
    }
    storage_config {
      cloud_storage_options {
        file_set {
          url = "gs://mybucket/directory/"
        }
      }
    }
  }
}
