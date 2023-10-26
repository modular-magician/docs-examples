resource "google_dialogflow_cx_agent" "agent" {
  display_name          = "dialogflowcx-agent-${local.name_suffix}"
  location              = "global"
  default_language_code = "en"
  time_zone             = "America/New_York"
}


resource "google_dialogflow_cx_intent" "default_welcome_intent" {
  parent       = google_dialogflow_cx_agent.agent.id
  name         = "00000000-0000-0000-0000-000000000000"
  display_name = "Default Welcome Intent"
  priority     = 1
  training_phrases {
    parts {
      text = "Hello"
    }
    repeat_count = 1
  }
}
