resource "google_iam_workforce_pool" "pool" {
  workforce_pool_id = "example-pool-${local.name_suffix}"
  parent            = "organizations/ORG_ID"
  location          = "global"
}

resource "google_iam_workforce_pool_provider" "example" {
  workforce_pool_id  = google_iam_workforce_pool.pool.workforce_pool_id
  location           = google_iam_workforce_pool.pool.location
  provider_id        = "example-prvdr-${local.name_suffix}"
  attribute_mapping  = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    issuer_uri       = "https://accounts.thirdparty.com"
    client_id        = "client-id"
    client_secret {
      value {
        plain_text = "client-secret"
      }
    }
    web_sso_config {
      response_type             = "CODE"
      assertion_claims_behavior = "MERGE_USER_INFO_OVER_ID_TOKEN_CLAIMS"
    }
  }
}
