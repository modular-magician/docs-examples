resource "google_workbench_instance" "instance" {
  name = "workbench-instance-${local.name_suffix}"
  location = "us-central1-a"

  gce_setup {
    machine_type = "e2-standard-4"

    shielded_instance_config {
      enable_secure_boot = false
      enable_vtpm = false
      enable_integrity_monitoring = false
    }

    service_accounts {
      email = "SERVICE_ACCT"
    }

    metadata = {
      terraform = "true"
    }

  }

  labels = {
    k = "val"
  }

  desired_state = "STOPPED"

}
