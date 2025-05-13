data "google_billing_account" "account" {
  billing_account = "MASTER_BILLING_ACCT"
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name = "Example Billing Budget-${local.name_suffix}"
  amount {
    specified_amount {
      currency_code = "USD"
      units = "100000"
    }
  }
  threshold_rules {
      threshold_percent =  0.5
  }
}
