resource "google_iam_principal_access_boundary_policy" "pab-policy-for-org" {
  organization   = "ORG_ID"
  location       = "global"
  display_name   = "PAB policy for Organization-${local.name_suffix}"
  principal_access_boundary_policy_id = "pab-policy-for-org-${local.name_suffix}"
}
