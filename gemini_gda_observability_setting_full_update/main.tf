resource "google_gemini_gda_observability_setting" "example" {
    gda_observability_setting_id = "ls1-tf-${local.name_suffix}"
    location = "global"
    labels = {"updated_key": "updated_value"}
    conversational_analytics_setting {
        feedback_enabled = true
        logging_enabled = true
        metrics_enabled = true
        traces_enabled = true
    }
}
