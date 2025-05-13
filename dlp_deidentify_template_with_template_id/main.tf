resource "google_data_loss_prevention_deidentify_template" "with_template_id" {
  parent = "projects/PROJECT_NAME"
  template_id = "my-template-${local.name_suffix}"

  deidentify_config {
    info_type_transformations {
      transformations {
        info_types {
          name = "PHONE_NUMBER"
        }
        info_types {
          name = "AGE"
        }

        primitive_transformation {
          replace_config {
            new_value {
              integer_value = 9
            }
          }
        }
      }
    }
  }
}
