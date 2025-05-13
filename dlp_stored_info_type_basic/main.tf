resource "google_data_loss_prevention_stored_info_type" "basic" {
	parent = "projects/PROJECT_NAME"
	description = "Description"
	display_name = "Displayname"

	regex {
		pattern = "patient"
		group_indexes = [2]
	}
}
