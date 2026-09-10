resource "google_gemini_gda_observability_setting" "example" {
    gda_observability_setting_id = "ls1-tf-${local.name_suffix}"
    location = "global"
    labels = {"initial_key": "initial_value"}
    conversational_analytics_setting {
        feedback_enabled = false
        logging_enabled = false
        metrics_enabled = false
        traces_enabled = false
    }
}
