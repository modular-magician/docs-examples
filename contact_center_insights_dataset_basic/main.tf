resource "google_contact_center_insights_dataset" "default" {
  dataset_id   = "dataset-${local.name_suffix}"
  location     = "us-central1"
  display_name = "My Dataset"
  description  = "My Dataset Description"
  ttl          = "86400s"
  type         = "EVAL"
}
