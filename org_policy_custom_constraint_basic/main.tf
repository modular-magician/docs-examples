resource "google_org_policy_custom_constraint" "constraint" {

  name         = "custom.disableGkeAutoUpgrade-${local.name_suffix}"
  parent       = "organizations/ORG_ID"

  action_type    = "ALLOW"
  condition      = "resource.management.autoUpgrade == false"
  method_types   = ["CREATE", "UPDATE"]
  resource_types = ["container.googleapis.com/NodePool"]
}
