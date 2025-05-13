resource "google_data_loss_prevention_stored_info_type" "with_stored_info_type_id" {
  parent = "projects/PROJECT_NAME"
  description = "Description"
  display_name = "Displayname"
  stored_info_type_id = "id--${local.name_suffix}"

  regex {
    pattern = "patient"
    group_indexes = [2]
  }
}
