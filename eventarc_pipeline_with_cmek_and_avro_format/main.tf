resource "google_eventarc_pipeline" "primary" {
  location        = "us-central1"
  pipeline_id     = "some-pipeline-${local.name_suffix}"
  crypto_key_name = "some-key-${local.name_suffix}"
  destinations {
    http_endpoint {
      uri                      = "https://10.77.0.0:80/route"
      message_binding_template = "{\"headers\":{\"new-header-key\": \"new-header-value\"}}"
    }
    network_config {
      network_attachment = "projects/PROJECT_NAME/regions/us-central1/networkAttachments/some-network-attachment-${local.name_suffix}"
    }
    output_payload_format {
      avro {
        schema_definition = "{\"type\": \"record\", \"name\": \"my_record\", \"fields\": [{\"name\": \"my_field\", \"type\": \"string\"}]}"
      }
    }
  }
  input_payload_format {
    avro {
      schema_definition = "{\"type\": \"record\", \"name\": \"my_record\", \"fields\": [{\"name\": \"my_field\", \"type\": \"string\"}]}"
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
