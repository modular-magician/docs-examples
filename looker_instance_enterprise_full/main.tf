resource "google_looker_instance" "looker-instance" {
  name              = "my-instance-${local.name_suffix}"
  platform_edition  = "LOOKER_CORE_ENTERPRISE_ANNUAL"
  region            = "us-central1"
  private_ip_enabled = "true"
  public_ip_enabled  = "true"
  consumer_network = data.google_compute_network.looker-network.id
  reserved_range = "10.0.0.0/20"
  oauth_config {
    client_id = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }

  deny_maintenance_period {
    start_date {
      month = 12
      day   = 1
      year  = 2026
    }
    end_date {
      month = 12
      day   = 31
      year  = 2026
    }
    time {
      hours = 10
      minutes = 0
      seconds = 0
      nanos = 0
    }
  }

  maintenance_window {
    day_of_week = "FRIDAY"
    start_time {
      hours = 17
      minutes = 0
      seconds = 0
      nanos = 0
    }
  }

  admin_settings {
    allowed_email_domains = ["example.com"]
  }
}
 // This example assumes this network already exists.
 // The API creates a tenant network per network authorized for a
 // Looker instance and that network is not deleted when the user-created
 // network (consumer_network) is deleted, so this prevents issues
 // with tenant network quota.
 // If this network hasn't been created and you are using this example in your
 // config, add an additional network resource or change
 // this from "data"to "resource"
 data "google_compute_network" "looker-network" {
   name = "looker-test-network-${local.name_suffix}"
 }