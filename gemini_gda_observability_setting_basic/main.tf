resource "google_gemini_gda_observability_setting" "example" {
    gda_observability_setting_id = "ls1-tf-${local.name_suffix}"
    location = "global"
}
