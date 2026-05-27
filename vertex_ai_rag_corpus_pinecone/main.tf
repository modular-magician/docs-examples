resource "google_vertex_ai_rag_corpus" "default" {
  region       = "us-west1"
  display_name = "rag-corpus-pinecone-${local.name_suffix}"
  description  = "pinecone backend"
  vector_db_config {
    pinecone {
      index_name = "example-pinecone-index"
    }
  }
}
