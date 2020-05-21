resource "google_data_catalog_entry" "basic_entry" {
  entry_group = google_data_catalog_entry_group.entry_group.id
  entry_id = "my_entry-${local.name_suffix}"

  user_specified_type = "my_user_specified_type"
  user_specified_system = "Something_custom"
  linked_resource = "my/linked/resource"

  display_name = "my custom type entry"
  description  = "a custom type entry for a user specified system"

  schema = <<EOF
{
  "columns": [
    {
      "column": "first_name",
      "description": "First name",
      "mode": "REQUIRED",
      "type": "STRING"
    },
    {
      "column": "last_name",
      "description": "Last name",
      "mode": "REQUIRED",
      "type": "STRING"
    },
    {
      "column": "address",
      "description": "Address",
      "mode": "REPEATED",
      "subcolumns": [
        {
          "column": "city",
          "description": "City",
          "mode": "NULLABLE",
          "type": "STRING"
        },
        {
          "column": "state",
          "description": "State",
          "mode": "NULLABLE",
          "type": "STRING"
        }
      ],
      "type": "RECORD"
    }
  ]
}
EOF
}

resource "google_data_catalog_entry_group" "entry_group" {
  entry_group_id = "my_group-${local.name_suffix}"
}
