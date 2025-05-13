resource "google_dataplex_aspect_type" "test_entry_type_full" {
  aspect_type_id         = "tf-test-aspect-type%{random_suffix}"
  location     = "us-central1"
  project      = "PROJECT_NAME"

  metadata_template = <<EOF
{
  "name": "tf-test-template",
  "type": "record",
  "recordFields": [
    {
      "name": "type",
      "type": "enum",
      "annotations": {
        "displayName": "Type",
        "description": "Specifies the type of view represented by the entry."
      },
      "index": 1,
      "constraints": {
        "required": true
      },
      "enumValues": [
        {
          "name": "VIEW",
          "index": 1
        }
      ]
    }
  ]
}
EOF
}

resource "google_dataplex_entry_type" "test_entry_type_full" {
  entry_type_id = "entry-type-full-${local.name_suffix}"
  project = "PROJECT_NAME"
  location = "us-central1"

  labels = { "tag": "test-tf" }
  display_name = "terraform entry type"
  description = "entry type created by Terraform"

  type_aliases = ["TABLE", "DATABASE"]
  platform = "GCS"
  system = "CloudSQL"
  
  required_aspects {
    type = google_dataplex_aspect_type.test_entry_type_full.name
  }
}
