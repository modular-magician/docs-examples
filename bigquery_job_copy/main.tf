locals {
  count = 2
}

resource "google_bigquery_table" "source" {
  count = local.count

  dataset_id = google_bigquery_dataset.source[count.index].dataset_id
  table_id   = "job_copy-${local.name_suffix}_${count.index}_table"

  deletion_protection = false

  schema = <<EOF
[
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "post_abbr",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_dataset" "source" {
  count = local.count

  dataset_id                  = "job_copy-${local.name_suffix}_${count.index}_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "US"
}

resource "google_bigquery_table" "dest" {
  deletion_protection = false
  dataset_id = google_bigquery_dataset.dest.dataset_id
  table_id   = "job_copy-${local.name_suffix}_dest_table"

  schema = <<EOF
[
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "post_abbr",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF

  encryption_configuration {
    kms_key_name = "example-key-${local.name_suffix}"
  }

  depends_on = ["google_kms_crypto_key_iam_member.encrypt_role"]
}

resource "google_bigquery_dataset" "dest" {
  dataset_id    = "job_copy-${local.name_suffix}_dest_dataset"
  friendly_name = "test"
  description   = "This is a test description"
  location      = "US"
}

data "google_project" "project" {
  project_id = "PROJECT_NAME"
}

resource "google_kms_crypto_key_iam_member" "encrypt_role" {
  crypto_key_id = "example-key-${local.name_suffix}"
  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member = "serviceAccount:bq-${data.google_project.project.number}@bigquery-encryption.iam.gserviceaccount.com"
}

resource "google_bigquery_job" "job" {
  job_id     = "job_copy-${local.name_suffix}"

  copy {
    source_tables {
      project_id = google_bigquery_table.source.0.project
      dataset_id = google_bigquery_table.source.0.dataset_id
      table_id   = google_bigquery_table.source.0.table_id
    }

    source_tables {
      project_id = google_bigquery_table.source.1.project
      dataset_id = google_bigquery_table.source.1.dataset_id
      table_id   = google_bigquery_table.source.1.table_id
    }

    destination_table {
      project_id = google_bigquery_table.dest.project
      dataset_id = google_bigquery_table.dest.dataset_id
      table_id   = google_bigquery_table.dest.table_id
    }

    destination_encryption_configuration {
      kms_key_name = "example-key-${local.name_suffix}"
    }
  }

  depends_on = ["google_kms_crypto_key_iam_member.encrypt_role"]
}
