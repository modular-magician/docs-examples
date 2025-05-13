resource "google_dataplex_datascan" "basic_quality" {
  location     = "us-central1"
  data_scan_id = "dataquality-basic-${local.name_suffix}"

  data {
    resource = "//bigquery.googleapis.com/projects/bigquery-public-data/datasets/samples/tables/shakespeare"
  }

  execution_spec {
    trigger {
      on_demand {}
    }
  }

  data_quality_spec {
    rules {
      dimension = "VALIDITY"
      name = "rule1"
      description = "rule 1 for validity dimension"
      table_condition_expectation {
        sql_expression = "COUNT(*) > 0"
      }
    }
  }

  project = "PROJECT_NAME"
}
