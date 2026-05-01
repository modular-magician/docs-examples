data "google_project" "project" {}

resource "google_contact_center_insights_qa_question_tag" "default" {
  qa_question_tag_id = "tag-${local.name_suffix}"
  location           = "us-central1"
  display_name       = "My Question Tag tag-${local.name_suffix}"
}





