resource "google_monitoring_service" "my_service" {
  service_id = "my-service-${local.name_suffix}"
  display_name = "My Service my-service-${local.name_suffix}"

  user_labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }

  basic_service {
    service_type  = "APP_ENGINE"
    service_labels = {
      module_id = "another-module-id"
    }
  }
}
