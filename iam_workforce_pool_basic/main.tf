resource "google_iam_workforce_pool" "example" {
  workforce_pool_id = "example-pool-${local.name_suffix}"
  parent            = "organizations/ORG_ID"
  location          = "global"
}
