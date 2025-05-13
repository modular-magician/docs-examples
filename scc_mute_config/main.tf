resource "google_scc_mute_config" "default" {
  mute_config_id = "my-config-${local.name_suffix}"
  parent         = "organizations/ORG_ID"
  filter         = "category: \"OS_VULNERABILITY\""
  description    = "My Mute Config"
  type           = "DYNAMIC"
  expiry_time    = "2215-02-03T15:01:23Z"
}
