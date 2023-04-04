data "google_project" "project" {
  project_id = ""
}

resource "google_project_iam_member" "kms-secret-binding" {
  project = data.google_project.project.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-secretmanager.iam.gserviceaccount.com"
}

resource "google_secret_manager_secret" "cmek" {
  secret_id = "secret-cmek-${local.name_suffix}"
  project = data.google_project.project.project_id
  
  labels = {
    label = "my-label"
  }
  replication {
    user_managed {
      replicas {
		location = "us-central1"
		customer_managed_encryption {
			kms_key_name = ""
		}
	  }
	replicas {
		location = "us-east1"
		customer_managed_encryption {
			kms_key_name = ""
		}
      }
	  
    }
  }
}
