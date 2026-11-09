resource "google_identity_platform_tenant" "tenant" {
  display_name          = "tenant"
  allow_password_signup = true

password_policy_config {
    password_policy_enforcement_state = "OFF"
    force_upgrade_on_signin = false
  }
}
