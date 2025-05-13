resource "google_iam_principal_access_boundary_policy" "pab_policy" {
  organization   = "ORG_ID"
  location       = "global"
  display_name   = "binding for all principals in the folder-${local.name_suffix}"
  principal_access_boundary_policy_id = "my-pab-policy-${local.name_suffix}"
}

resource "google_folder" "folder" {
  display_name        = "my folder-${local.name_suffix}"
  parent              = "organizations/ORG_ID"
  deletion_protection = false
}

resource "time_sleep" "wait_120s" {
  depends_on      = [google_folder.folder]
  create_duration = "120s"
}

resource "google_iam_folders_policy_binding" "binding-for-all-folder-principals" {
  folder         = google_folder.folder.folder_id
  location       = "global"
  display_name   = "binding for all principals in the folder-${local.name_suffix}"
  policy_kind    = "PRINCIPAL_ACCESS_BOUNDARY"
  policy_binding_id = "binding-for-all-folder-principals-${local.name_suffix}"
  policy         = "organizations/ORG_ID/locations/global/principalAccessBoundaryPolicies/${google_iam_principal_access_boundary_policy.pab_policy.principal_access_boundary_policy_id}"
  target {
    principal_set = "//cloudresourcemanager.googleapis.com/folders/${google_folder.folder.folder_id}"
  }
  depends_on = [time_sleep.wait_120s]
}
