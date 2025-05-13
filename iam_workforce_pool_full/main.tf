resource "google_iam_workforce_pool" "example" {
  workforce_pool_id   = "example-pool-${local.name_suffix}"
  parent              = "organizations/ORG_ID"
  location            = "global"
  display_name        = "Display name"
  description         = "A sample workforce pool."
  disabled            = false
  session_duration    = "7200s"
  access_restrictions {
    allowed_services {
      domain = "backstory.chronicle.security"
    }
    disable_programmatic_signin = false
  }
}
