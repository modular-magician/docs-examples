resource "google_vertex_ai_rag_corpus" "example" {
  display_name = "rag-corpus-full-${local.name_suffix}"
  description  = "A RAG corpus with a customer-managed encryption key"
  region       = "europe-west4"

  vector_db_config {
    rag_managed_db {
      ann {
        tree_depth = 2
        leaf_count = 500
      }
    }

    rag_embedding_model_config {
      vertex_prediction_endpoint {
        endpoint = "projects/${data.google_project.project.number}/locations/europe-west4/publishers/google/models/text-embedding-005"
      }
    }
  }

  encryption_spec {
    kms_key_name = "kms-key-${local.name_suffix}"
  }
}

data "google_project" "project" {
}
