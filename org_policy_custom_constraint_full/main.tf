resource "google_org_policy_custom_constraint" "constraint" {

  name         = "custom.disableGkeAutoUpgrade-${local.name_suffix}"
  parent       = "organizations/ORG_TARGET"
  display_name = "Disable GKE auto upgrade"
  description  = "Only allow GKE NodePool resource to be created or updated if AutoUpgrade is not enabled where this custom constraint is enforced."

  action_type    = "ALLOW"
  condition      = "resource.management.autoUpgrade == false"
  method_types   = ["CREATE", "UPDATE"]
  resource_types = ["container.googleapis.com/NodePool"]
}

resource "google_org_policy_policy" "bool" {

  name   = "organizations/ORG_TARGET/policies/${google_org_policy_custom_constraint.constraint.name}"
  parent = "organizations/ORG_TARGET"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}
