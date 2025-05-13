resource "google_scc_v2_organization_mute_config" "default" {
  mute_config_id    = "my-config-${local.name_suffix}"
  organization = "ORG_ID"
  location     = "global"
  description  = "My custom Cloud Security Command Center Finding Organization mute Configuration"
  filter = "severity = \"HIGH\""
  type = "STATIC"
}
