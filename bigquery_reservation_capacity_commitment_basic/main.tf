resource "google_bigquery_reservation_capacity_commitment" "commitment" {
	capacity_commitment_id = "my-commitment-${local.name_suffix}"
	location               = "asia-northeast1"
	slot_count             = 100
	plan                   = "FLEX"
}
