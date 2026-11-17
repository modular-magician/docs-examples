resource "google_vertex_ai_evaluation_item" "evaluation_item" {
  region               = "us-central1"
  display_name         = "eval-item-${local.name_suffix}"
  evaluation_item_type = "REQUEST"
  evaluation_request {
    prompt {
      text = "hello"
    }
  }
}

resource "google_vertex_ai_evaluation_item" "evaluation_item_2" {
  region               = "us-central1"
  display_name         = "eval-item-2-${local.name_suffix}"
  evaluation_item_type = "REQUEST"
  evaluation_request {
    prompt {
      text = "What is the largest planet in our solar system?"
    }
  }
}

resource "google_vertex_ai_evaluation_set" "evaluation_set" {
  region       = "us-central1"
  display_name = "eval-set-${local.name_suffix}"
  evaluation_items = [
    google_vertex_ai_evaluation_item.evaluation_item.id,
    google_vertex_ai_evaluation_item.evaluation_item_2.id,
  ]
  metadata = jsonencode({
    "env" = "test"
  })
}
