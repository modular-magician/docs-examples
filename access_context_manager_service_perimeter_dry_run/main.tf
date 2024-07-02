resource "google_access_context_manager_service_perimeter" "service-perimeter" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}/servicePerimeters/restrict_bigquery_dryrun_storage-${local.name_suffix}"
  title  = "restrict_bigquery_dryrun_storage-${local.name_suffix}"

  # Service 'bigquery.googleapis.com' will be restricted.
  status {
    restricted_services = ["bigquery.googleapis.com"]
  }

  # Service 'storage.googleapis.com' will be in dry-run mode.
  spec {
    restricted_services = ["storage.googleapis.com"]
  }

  use_explicit_dry_run_spec = true

}

resource "google_access_context_manager_access_policy" "access-policy" {
  parent = "organizations/123456789"
  title  = "my policy"
}
