resource "google_vertex_ai_rag_corpus" "rag_corpus" {
  display_name = "rc-full-${local.name_suffix}"
  description  = "A full RAG corpus created by Terraform"
  region       = "us-west1"

  vector_db_config {
    rag_embedding_model_config {
      vertex_prediction_endpoint {
        endpoint = "projects/${data.google_project.project.project_id}/locations/us-west1/publishers/google/models/text-embedding-005"
      }
    }
    rag_managed_db {
      ann {
        tree_depth = 3
        leaf_count = 100
      }
    }
  }

  encryption_spec {
    kms_key_name = "kms-name-${local.name_suffix}"
  }

  depends_on = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = "kms-name-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-vertex-rag.iam.gserviceaccount.com"
}

data "google_project" "project" {}
