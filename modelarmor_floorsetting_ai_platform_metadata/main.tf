resource "google_model_armor_floorsetting" "floorsetting-integrated-metadata" {
  location    = "<no value>"
  parent      = "<no value>"

  filter_config {
  
  }

  enable_floor_setting_enforcement = "<no value>"
  
  ai_platform_floor_setting {
    inspect_only            = <no value>
    enable_cloud_logging    = <no value>
  }
  
  floor_setting_metadata {
    multi_language_detection {
      enable_multi_language_detection = <no value>
    }
  }
}
