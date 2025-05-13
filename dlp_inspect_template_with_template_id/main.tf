resource "google_data_loss_prevention_inspect_template" "with_template_id" {
  parent = "projects/PROJECT_NAME"
  template_id = "my-template-${local.name_suffix}"

  inspect_config {
    info_types {
      name = "EMAIL_ADDRESS"
    }
    info_types {
      name = "PERSON_NAME"
    }

    min_likelihood = "UNLIKELY"
    rule_set {
      info_types {
        name = "EMAIL_ADDRESS"
      }
      rules {
        exclusion_rule {
          regex {
            pattern = ".+@example.com"
          }
          matching_type = "MATCHING_TYPE_FULL_MATCH"
        }
      }
    }

    rule_set {
      info_types {
        name = "PERSON_NAME"
      }
      rules {
        hotword_rule {
          hotword_regex {
            pattern = "patient"
          }
          proximity {
            window_before = 50
          }
          likelihood_adjustment {
            fixed_likelihood = "VERY_LIKELY"
          }
        }
      }
    }
  }
}
