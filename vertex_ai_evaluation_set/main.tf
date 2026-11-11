resource "google_vertex_ai_evaluation_item" "eval-item-${local.name_suffix}" {
  region               = "us-central1"
  display_name         = "eval-item-${local.name_suffix}"
  evaluation_item_type = "REQUEST"
  evaluation_request {
    prompt {
      text = "hello"
    }
  }
}

resource "google_vertex_ai_evaluation_set" "evaluation_set" {
  region           = "us-central1"
  display_name     = "eval-set-${local.name_suffix}"
  evaluation_items = [
    google_vertex_ai_evaluation_item.eval-item-${local.name_suffix}.id
  ]
  metadata = jsonencode({
    "env" = "test"
  })
}
