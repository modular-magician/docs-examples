resource "google_dialogflow_companion_agent" "default" {
  location           = "global"
  companion_agent_id = "companion_agent-${local.name_suffix}"
  display_name       = "companion-agent-updated"
  description        = "Updated Companion Agent Description"

  skill_configs {
    skill_triggering_event = "CUSTOMER_MESSAGE"
    translation_skill_config {
      agent_language_code    = "en-GB"
      customer_language_code = "fr"
    }
  }

  skill_configs {
    skill_triggering_event = "END_OF_UTTERANCE"
    guidance_skill_config {
      overarching_guidance = "Always provide helpful answers"
      guidance_instructions {
        display_name            = "greeting"
        display_details         = "Greeting for the customer"
        condition               = "Customer starts conversation"
        disable_suggested_reply = false
        trigger_event           = "CUSTOMER_MESSAGE"
        actions {
          description = "Greet customer warmly"
        }
      }
    }
  }
}
