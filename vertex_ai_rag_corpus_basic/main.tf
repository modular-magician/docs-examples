resource "google_vertex_ai_rag_corpus" "default" {
  region       = "us-west1"
  display_name = "rag-corpus-${local.name_suffix}"
  description  = "basic description"
  vector_db_config {
    rag_managed_db {
      ann {
        leaf_count = 500
        tree_depth = 2
      }
    }
  }
}
