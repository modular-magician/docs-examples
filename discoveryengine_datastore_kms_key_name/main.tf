resource "google_discovery_engine_data_store" "kms_key_name" {
  location                     = "us"
  data_store_id                = "data-store-id-${local.name_suffix}"
  display_name                 = "tf-test-structured-datastore"
  industry_vertical            = "GENERIC"
  content_config               = "NO_CONTENT"
  solution_types               = ["SOLUTION_TYPE_SEARCH"]
  kms_key_name                 = "kms-key-${local.name_suffix}"
  create_advanced_site_search  = false
  skip_default_schema_creation = false

  depends_on = [google_discovery_engine_cmek_config.default]
}

resource "google_discovery_engine_cmek_config" "default" {
  location       = "us"
  cmek_config_id = "cmek-config-id-${local.name_suffix}"
  kms_key        = "kms-key-${local.name_suffix}"
  set_default    = false

  depends_on = [google_kms_crypto_key_iam_member.crypto_key]
}

data "google_project" "project" {}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = "kms-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-discoveryengine.iam.gserviceaccount.com"
}
