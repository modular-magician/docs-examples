resource "google_monitoring_service" "custom" {
  service_id = ""
  display_name = "My Custom Service "

  telemetry {
  	resource_name = ""
  }
}
