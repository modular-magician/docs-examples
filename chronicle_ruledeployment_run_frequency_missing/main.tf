resource "google_chronicle_rule" "my-rule" {
 location = "us"
 instance = "CHRONICLE_ID"
 text = <<-EOT
             rule test_rule { meta: events:  $userid = $e.principal.user.userid  match: $userid over 10m condition: $e }
         EOT
}

resource "google_chronicle_rule_deployment" "example" {
 location = "us"
 instance = "CHRONICLE_ID"
 rule = element(split("/", resource.google_chronicle_rule.my-rule.name), length(split("/", resource.google_chronicle_rule.my-rule.name)) - 1)
 enabled = true
 alerting = true
 archived = false
}
