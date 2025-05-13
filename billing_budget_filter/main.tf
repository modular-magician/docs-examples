data "google_billing_account" "account" {
  billing_account = "MASTER_BILLING_ACCT"
}

data "google_project" "project" {
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name = "Example Billing Budget-${local.name_suffix}"

  budget_filter {
    projects               = ["projects/${data.google_project.project.number}"]
    credit_types_treatment = "INCLUDE_SPECIFIED_CREDITS"
    services               = ["services/24E6-581D-38E5"] # Bigquery
    credit_types           = ["PROMOTION", "FREE_TIER"]
    resource_ancestors     = ["organizations/ORG_ID"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units = "100000"
    }
  }

  threshold_rules {
    threshold_percent = 0.5
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis = "FORECASTED_SPEND"
  }
}
