resource "google_eventarc_pipeline" "primary" {
  location    = "us-central1"
  pipeline_id = "some-pipeline-${local.name_suffix}"
  destinations {
    http_endpoint {
      uri                      = "https://10.77.0.0:80/route"
      message_binding_template = "{\"headers\":{\"new-header-key\": \"new-header-value\"}}"
    }
    network_config {
      network_attachment = "projects/PROJECT_NAME/regions/us-central1/networkAttachments/some-network-attachment-${local.name_suffix}"
    }
    authentication_config {
      oauth_token {
        service_account = "SERVICE_ACCT"
        scope           = "https://www.googleapis.com/auth/cloud-platform"
      }
    }
    output_payload_format {
      protobuf {
        schema_definition = <<-EOF
syntax = "proto3";
message schema {
string name = 1;
string severity = 2;
}
EOF
      }
    }
  }
  input_payload_format {
    protobuf {
      schema_definition = <<-EOF
syntax = "proto3";
message schema {
string name = 1;
string severity = 2;
}
EOF
    }
  }
  retry_policy {
    max_retry_delay = "50s"
    max_attempts    = 2
    min_retry_delay = "40s"
  }
  mediations {
    transformation {
      transformation_template = <<-EOF
{
"id": message.id,
"datacontenttype": "application/json",
"data": "{ \"scrubbed\": \"true\" }"
}
EOF
    }
  }
  logging_config {
    log_severity = "DEBUG"
  }
}
