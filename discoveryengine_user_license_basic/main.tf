resource "google_discovery_engine_license_config" "basic" {
  location          = "global"
  license_config_id = "lc-id-${local.name_suffix}"
  license_count     = 50
  subscription_tier = "SUBSCRIPTION_TIER_NOTEBOOK_LM"
  start_date {
    year  = 2099
    month = 1
    day   = 1
  }
  end_date {
    year  = 2100
    month = 1
    day   = 1
  }
  subscription_term = "SUBSCRIPTION_TERM_ONE_YEAR"
}

resource "google_discovery_engine_user_license" "primary" {
  location       = google_discovery_engine_license_config.basic.location
  user_principal = "user-${local.name_suffix}@example.com"
  license_config = google_discovery_engine_license_config.basic.name
  user_profile   = "Example User"
}
