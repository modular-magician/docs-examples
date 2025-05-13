data "google_billing_account" "account" {
  billing_account = "MASTER_BILLING_ACCT"
}

data "google_project" "project" {
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name = "Example Billing Budget-${local.name_suffix}"
  
  budget_filter {
    projects = ["projects/${data.google_project.project.number}"]
  }

  amount {
    last_period_amount = true
  }

  threshold_rules {
      threshold_percent =  10.0
      # Typically threshold_percent would be set closer to 1.0 (100%).
      # It has been purposely set high (10.0 / 1000%) in this example
      # so it does not trigger alerts during automated testing.
  }
}
