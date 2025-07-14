resource "google_bigquery_analytics_hub_data_exchange" "approvequerytemplate" {
display_name = "My Audience Data Exchange"
data_exchange_id = "my_data_exchange-${local.name_suffix}"
description = "example of query template-${local.name_suffix}"
location = "us"
sharing_environment_config {
dcr_exchange_config {}
}
}

resource "google_bigquery_analytics_hub_query_template" "approvequerytemplate" {
location = "us"
data_exchange_id = google_bigquery_analytics_hub_data_exchange.approvequerytemplate.data_exchange_id
query_template_id = "qt1-${local.name_suffix}"
display_name = "qt1-${local.name_suffix}"
description = "example of query template-${local.name_suffix}"
primary_contact = "admin@example.com"
documentation = "This TVF takes a table t1 as input and returns all columns. Useful for basic data pass-through."
routine {
routine_type="TABLE_VALUED_FUNCTION"
definition_body="qt1-${local.name_suffix}() as (select * from t1)"
}
submit=true
} 

resource "google_bigquery_analytics_hub_approve_query_template" "approvequerytemplate" {
  location         = "us" 
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.approvequerytemplate.data_exchange_id
  query_template_id = "qt1-${local.name_suffix}"
  depends_on = [google_bigquery_analytics_hub_query_template.approvequerytemplate]
}
