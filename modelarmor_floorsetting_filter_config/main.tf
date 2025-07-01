resource "google_model_armor_floorsetting" "floorsetting-filter-config" {
  location    = "<no value>"
  parent      = "<no value>"

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "<no value>"
        confidence_level = "<no value>"
      }
    }
    sdp_settings {
      basic_config {
          filter_enforcement = "<no value>"
      }
    }
    pi_and_jailbreak_filter_settings {
      filter_enforcement = "<no value>"
      confidence_level   = "<no value>"
    }
    malicious_uri_filter_settings {
      filter_enforcement = "<no value>"
    }
  }

  enable_floor_setting_enforcement = <no value>
}
