resource "google_chronicle_data_access_scope" "data_access_scope_test" {
 location = "us"
 instance = "CHRONICLE_ID"
 data_access_scope_id = "scope-name-${local.name_suffix}"
 description = "scope-description"
 allowed_data_access_labels {
   log_type = "GCP_CLOUDAUDIT"
 }
}

resource "google_chronicle_rule" "example" {
 location = "us"
 instance = "CHRONICLE_ID"
 scope = resource.google_chronicle_data_access_scope.data_access_scope_test.name
 text = <<-EOT
             rule test_rule { meta: events:  $userid = $e.principal.user.userid  match: $userid over 10m condition: $e }
         EOT
}
