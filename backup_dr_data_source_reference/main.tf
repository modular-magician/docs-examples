terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

# NOTE: This example assumes a DataSourceReference with the specified ID
# already exists in the given project and location.

data "google_backup_dr_data_source_reference" "my_dsr" {
  provider                 = google-beta
  data_source_reference_id = "example-dsr-id-${local.name_suffix}"
  location                 = "us-central1-${local.name_suffix}"
  # project                  = "your-project-id-${local.name_suffix}" # Optional
}

output "dsr_data_source" {
  value = data.google_backup_dr_data_source_reference.my_dsr.data_source
}
