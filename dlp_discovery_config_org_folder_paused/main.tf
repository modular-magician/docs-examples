resource "google_data_loss_prevention_discovery_config" "org_folder_paused" {
	parent = "organizations/ORG_ID/locations/us"
    location = "us"

    targets {
        big_query_target {
            filter {
                other_tables {}
            }
        }
    }
    org_config {
        project_id = "PROJECT_NAME"
        location {
            folder_id = 123
        }
    }
    inspect_templates = ["projects/%{project}/inspectTemplates/${google_data_loss_prevention_inspect_template.basic.name}"]
    status = "PAUSED"
}

resource "google_data_loss_prevention_inspect_template" "basic" {
	parent = "projects/PROJECT_NAME"
	description = "My description"
	display_name = "display_name"

	inspect_config {
		info_types {
			name = "EMAIL_ADDRESS"
		}
    }
}
