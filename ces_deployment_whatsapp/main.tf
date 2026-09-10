resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {
        time_zone = "America/Los_Angeles"
    }
}
resource "google_ces_app_version" "my-app-version" {
    location       = "us"
    display_name   = "my-app-version-${local.name_suffix}"
    app            = google_ces_app.my-app.name
    app_version_id = "app-version-id-${local.name_suffix}"
    description    = "example-app-version"
}
resource "google_ces_deployment" "my-deployment" {
    location     = "us"
    display_name = "my-deployment-${local.name_suffix}"
    app          = google_ces_app.my-app.name
    app_version  = google_ces_app_version.my-app-version.id
    channel_profile {
        channel_type = "API"
        profile_id = "temp_profile_id"
        whatsapp_config {
            phone_number = "+15551234567"
            phone_number_id = "1234567890"
            waba_id = "9876543210"
        }
    }
}
