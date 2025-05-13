data "google_billing_account" "account" {
  billing_account = "MASTER_BILLING_ACCT"
}

data "google_project" "project" {
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name    = "Example Billing Budget-${local.name_suffix}"

  budget_filter {
    projects = ["projects/${data.google_project.project.number}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = "100000"
    }
  }

  all_updates_rule {
    monitoring_notification_channels = []
    enable_project_level_recipients  = true
  }
}
