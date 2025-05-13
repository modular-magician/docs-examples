resource "google_data_loss_prevention_job_trigger" "bigquery_row_limit" {
	parent = "projects/PROJECT_NAME"
	description = "Description"
	display_name = "Displayname"

	triggers {
		schedule {
			recurrence_period_duration = "86400s"
		}
	}

	inspect_job {
		inspect_template_name = "fake"
		actions {
			save_findings {
				output_config {
					table {
						project_id = "project"
						dataset_id = "dataset"
					}
				}
			}
		}
		storage_config {
			big_query_options {
				table_reference {
				    project_id = "project"
				    dataset_id = "dataset"
				    table_id = "table_to_scan"
				}

				rows_limit = 1000
				sample_method = "RANDOM_START"
			}
		}
	}
}
