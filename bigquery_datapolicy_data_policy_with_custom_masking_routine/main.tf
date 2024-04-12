data "google_project" "project" {
}

resource "google_bigquery_datapolicy_data_policy" "data_policy" {
  location         = "us-central1"
  data_policy_id   = "data_policy_id-${local.name_suffix}"
  policy_tag       = google_data_catalog_policy_tag.policy_tag.name
  data_policy_type = "DATA_MASKING_POLICY"
  data_masking_policy {
    routine = format("projects/%s/datasets/%s/routines/%s", data.google_project.project.number, google_bigquery_routine.custom_masking_routine.dataset_id, google_bigquery_routine.custom_masking_routine.routine_id)
  }
}

resource "google_data_catalog_policy_tag" "policy_tag" {
  taxonomy     = google_data_catalog_taxonomy.taxonomy.id
  display_name = "Low security"
  description  = "A policy tag normally associated with low security items"
}

resource "google_data_catalog_taxonomy" "taxonomy" {
  region                 = "us-central1"
  display_name           = "taxonomy-${local.name_suffix}"
  description            = "A collection of policy tags"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "dataset_id-${local.name_suffix}"
  location   = "us-central1"
}

resource "google_bigquery_routine" "custom_masking_routine" {
  dataset_id           = google_bigquery_dataset.dataset.dataset_id
  routine_id           = "routine_id-${local.name_suffix}"
  routine_type         = "SCALAR_FUNCTION"
  language             = "SQL"
  data_governance_type = "DATA_MASKING"
  definition_body      = "SAFE.REGEXP_REPLACE(ssn, '[0-9]', 'X')"
  arguments {
    name               = "ssn"
    data_type          = "{\"typeKind\" :  \"STRING\"}"
  }
  return_type          = "{\"typeKind\" :  \"STRING\"}"
}
