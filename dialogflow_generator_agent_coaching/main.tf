resource "google_dialogflow_generator" "agent_coaching_generator" {
  location = "global"
  description = "An agent coaching generator."
  agent_coaching_context {
    version = "1.0"
    overarching_guidance = "Be helpful."
  }
}
