resource "google_agentic_applications_analyst_agent_persona" "primary" {
  analyst_agent_persona_id = "persona-id-${local.name_suffix}"
  location                 = "us"
  display_name             = "My Analyst Agent Persona"
  display_description      = "Sample persona description"
  model_description        = "Persona model description"
  role                     = "ANALYST_ROLE_GENERIC_FINANCE_ANALYST"
}
