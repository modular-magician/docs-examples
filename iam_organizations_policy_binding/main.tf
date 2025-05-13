resource "google_iam_principal_access_boundary_policy" "pab_policy" {
  organization   = "ORG_ID"
  location       = "global"
  display_name   = "binding for all principals in the Organization-${local.name_suffix}"
  principal_access_boundary_policy_id = "my-pab-policy-${local.name_suffix}"
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on = [google_iam_principal_access_boundary_policy.pab_policy]
}

resource "google_iam_organizations_policy_binding" "binding-for-all-org-principals" {
  depends_on = [time_sleep.wait_60_seconds]
  organization   = "ORG_ID"
  location       = "global"
  display_name   = "binding for all principals in the Organization-${local.name_suffix}"
  policy_kind    = "PRINCIPAL_ACCESS_BOUNDARY"
  policy_binding_id = "binding-for-all-org-principals-${local.name_suffix}"
  policy         = "organizations/ORG_ID/locations/global/principalAccessBoundaryPolicies/${google_iam_principal_access_boundary_policy.pab_policy.principal_access_boundary_policy_id}"
  target {
    principal_set = "//cloudresourcemanager.googleapis.com/organizations/ORG_ID"
  }
}
