resource "google_dataplex_datascan" "basic_profile" {
  location     = "us-central1"
  data_scan_id = "dataprofile-basic-${local.name_suffix}"

  data {
	  resource = "//bigquery.googleapis.com/projects/bigquery-public-data/datasets/samples/tables/shakespeare"
  }

  execution_spec {
    trigger {
      on_demand {}
    }
  }

data_profile_spec {}

  project = "PROJECT_NAME"
}
