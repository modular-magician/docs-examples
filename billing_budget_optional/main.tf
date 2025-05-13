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

  all_updates_rule {
    disable_default_iam_recipients = true
    pubsub_topic = google_pubsub_topic.budget.id
  }

  ownership_scope = "BILLING_ACCOUNT"
}

resource "google_pubsub_topic" "budget" {
  name = "example-topic-${local.name_suffix}"
}
