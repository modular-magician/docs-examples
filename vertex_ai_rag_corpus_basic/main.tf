resource "google_vertex_ai_rag_corpus" "example" {
  display_name = "rag-corpus-${local.name_suffix}"
  description  = "A basic RAG corpus"
  region       = "europe-west4"

  vector_db_config {
    rag_managed_db {
      knn {}
    }

    rag_embedding_model_config {
      vertex_prediction_endpoint {
        endpoint = "projects/${data.google_project.project.number}/locations/europe-west4/publishers/google/models/text-embedding-005"
      }
    }
  }
}

data "google_project" "project" {
}
