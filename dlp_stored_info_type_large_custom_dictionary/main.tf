resource "google_data_loss_prevention_stored_info_type" "large" {
	parent = "projects/PROJECT_NAME"
	description = "Description"
	display_name = "Displayname"

	large_custom_dictionary {
		cloud_storage_file_set {
			url = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
		}
		output_path {
			path = "gs://${google_storage_bucket.bucket.name}/output/dictionary.txt"
		}
	}
}

resource "google_storage_bucket" "bucket" {
  name          = "tf-test-bucket-${local.name_suffix}"
  location      = "US"
  force_destroy = true
}

resource "google_storage_bucket_object" "object" {
  name   = "tf-test-object-${local.name_suffix}"
  bucket = google_storage_bucket.bucket.name
  source = "./test-fixtures/words.txt"
}
