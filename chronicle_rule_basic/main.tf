resource "google_chronicle_rule" "example" {
 location = "us"
 instance = "CHRONICLE_ID"
 deletion_policy = "DEFAULT"
 text = <<-EOT
             rule test_rule { meta: events:  $userid = $e.principal.user.userid  match: $userid over 10m condition: $e }
         EOT
}
