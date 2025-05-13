resource "google_chronicle_rule" "my-rule" {
 location = "us"
 instance = "CHRONICLE_ID"
 deletion_policy = "FORCE"
 text = <<-EOT
             rule test_rule { meta: events:  $userid = $e.principal.user.userid  match: $userid over 10m condition: $e }
         EOT
}

resource "google_chronicle_retrohunt" "example" {
 location = "us"
 instance = "CHRONICLE_ID"
 rule = element(split("/", resource.google_chronicle_rule.my-rule.name), length(split("/", resource.google_chronicle_rule.my-rule.name)) - 1)
 process_interval {
    start_time = "2025-01-01T00:00:00Z-${local.name_suffix}"
    end_time = "2025-01-01T12:00:00Z-${local.name_suffix}"
 }
}
