resource "google_vertex_ai_rag_corpus" "rag_corpus" {
  display_name = "rc-basic-${local.name_suffix}"
  description  = "A basic RAG corpus created by Terraform"
  region       = "us-west1"
}
