resource "google_healthcare_hl7_v2_store" "default" {
  provider = google-beta
  name    = "example-hl7-v2-store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id

  parser_config {
    allow_null_header  = false
    segment_terminator = "Jw=="
    schema = <<EOF
{
  "schemas": [{
    "messageSchemaConfigs": {
      "ADT_A01": {
        "name": "ADT_A01",
        "minOccurs": 1,
        "maxOccurs": 1,
        "members": [{
            "segment": {
              "type": "MSH",
              "minOccurs": 1,
              "maxOccurs": 1
            }
          },
          {
            "segment": {
              "type": "EVN",
              "minOccurs": 1,
              "maxOccurs": 1
            }
          },
          {
            "segment": {
              "type": "PID",
              "minOccurs": 1,
              "maxOccurs": 1
            }
          },
          {
            "segment": {
              "type": "ZPD",
              "minOccurs": 1,
              "maxOccurs": 1
            }
          },
          {
            "segment": {
              "type": "OBX"
            }
          },
          {
            "group": {
              "name": "PROCEDURE",
              "members": [{
                  "segment": {
                    "type": "PR1",
                    "minOccurs": 1,
                    "maxOccurs": 1
                  }
                },
                {
                  "segment": {
                    "type": "ROL"
                  }
                }
              ]
            }
          },
          {
            "segment": {
              "type": "PDA",
              "maxOccurs": 1
            }
          }
        ]
      }
    }
  }],
  "types": [{
    "type": [{
        "name": "ZPD",
        "primitive": "VARIES"
      }

    ]
  }],
  "ignoreMinOccurs": true
}
EOF
  }
}

resource "google_healthcare_dataset" "dataset" {
  provider = google-beta
  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}
