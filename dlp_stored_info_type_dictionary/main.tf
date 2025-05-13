resource "google_data_loss_prevention_stored_info_type" "dictionary" {
	parent = "projects/PROJECT_NAME"
	description = "Description"
	display_name = "Displayname"

	dictionary {
		word_list {
			words = ["word", "word2"]
		}
	}
}
